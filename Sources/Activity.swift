//
//  Activity.swift
//
//  Created by Zachary Waldowski on 8/21/16.
//  Copyright © 2016 Zachary Waldowski. Licensed under MIT.
//

import os.activity

private final class LegacyActivityContext {
    let dsoHandle: UnsafeRawPointer?
    let description: UnsafePointer<CChar>
    let flags: os_activity_flag_t
    
    init(dsoHandle: UnsafeRawPointer?, description: UnsafePointer<CChar>, flags: os_activity_flag_t) {
        self.dsoHandle = dsoHandle
        self.description = description
        self.flags = flags
    }
}

@available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
@_silgen_name("_os_activity_create")
private func _os_activity_create(_ dso: UnsafeRawPointer?,
                                 _ description: UnsafePointer<Int8>,
                                 _ parent: Unmanaged<AnyObject>?,
                                 _ flags: os_activity_flag_t) -> AnyObject!

@available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
@_silgen_name("os_activity_apply")
private func _os_activity_apply(_ storage: AnyObject,
                                _ block: @convention(block) () -> Void)

@_silgen_name("_os_activity_initiate")
private func __os_activity_initiate(_ dso: UnsafeRawPointer?,
                                    _ description: UnsafePointer<Int8>,
                                    _ flags: os_activity_flag_t,
                                    _ block: @convention(block) () -> Void)

@available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
@_silgen_name("os_activity_scope_enter")
private func _os_activity_scope_enter(_ storage: AnyObject,
                                      _ state: UnsafeMutablePointer<os_activity_scope_state_s>)

@_silgen_name("_os_activity_start")
private func __os_activity_start(_ dso: UnsafeRawPointer?,
                                 _ description: UnsafePointer<Int8>,
                                 _ flags: os_activity_flag_t) -> UInt64

@available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
@_silgen_name("os_activity_scope_leave")
private func _os_activity_scope_leave(_ state: UnsafeMutablePointer<os_activity_scope_state_s>)

@_silgen_name("os_activity_end")
private func __os_activity_end(_ state: UInt64)

@available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
private let OS_ACTIVITY_NONE = unsafeBitCast(dlsym(UnsafeMutableRawPointer(bitPattern: -2), "_os_activity_none"), to: Unmanaged<AnyObject>.self)

@available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
private let OS_ACTIVITY_CURRENT = unsafeBitCast(dlsym(UnsafeMutableRawPointer(bitPattern: -2), "_os_activity_current"), to: Unmanaged<AnyObject>.self)

internal struct Activity {
    
    /// Support flags for OSActivity.
    internal struct Options: OptionSet {
        internal let rawValue: UInt32
        internal init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
        
        /// Detach a newly created activity from a parent activity, if any.
        ///
        /// If passed in conjunction with a parent activity, the activity will
        /// only note what activity "created" the new one, but will make the
        /// new activity a top level activity. This allows seeing what
        /// activity triggered work without actually relating the activities.
        internal static let detached = Options(rawValue: OS_ACTIVITY_FLAG_DETACHED.rawValue)
        /// Will only create a new activity if none present.
        ///
        /// If an activity ID is already present, a new activity will be
        /// returned with the same underlying activity ID.
        @available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
        internal static let ifNonePresent = Options(rawValue: OS_ACTIVITY_FLAG_IF_NONE_PRESENT.rawValue)
    }
    
    private let opaque: AnyObject
    
    /// Creates an activity.
    internal init(_ description: StaticString, dso: UnsafeRawPointer? = #dsohandle, options: Options = []) {
        self.opaque = description.withUTF8Buffer { (buf: UnsafeBufferPointer<UInt8>) -> AnyObject in
            let str = buf.baseAddress!.withMemoryRebound(to: Int8.self, capacity: 8, { $0 })
            let flags = os_activity_flag_t(rawValue: options.rawValue)
            if #available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) {
                return _os_activity_create(dso, str, OS_ACTIVITY_CURRENT, flags)
            } else {
                return LegacyActivityContext(dsoHandle: dso, description: str, flags: flags)
            }
        }
    }
    
    private func active(execute body: @convention(block) () -> Void) {
        if #available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) {
            _os_activity_apply(opaque, body)
        } else {
            let context = opaque as! LegacyActivityContext
            __os_activity_initiate(context.dsoHandle, context.description, context.flags, body)
        }
    }
    
    /// Executes a function body within the context of the activity.
    internal func active<Return>(execute body: () throws -> Return) rethrows -> Return {
        func impl(execute work: () throws -> Return, recover: (Error) throws -> Return) rethrows -> Return {
            var result: Return?
            var error: Error?
            active {
                do {
                    result = try work()
                } catch let e {
                    error = e
                }
            }
            if let e = error {
                return try recover(e)
            } else {
                return result!
            }
            
        }
        
        return try impl(execute: body, recover: { throw $0 })
    }
    
    /// Opaque structure created by `Activity.enter()` and restored using
    /// `leave()`.
    internal struct Scope {
        fileprivate var state = os_activity_scope_state_s()
        fileprivate init() {}
        
        /// Pops activity state to `self`.
        internal mutating func leave() {
            if #available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) {
                _os_activity_scope_leave(&state)
            } else {
                UnsafeRawPointer(bitPattern: Int(state.opaque.0)).map(Unmanaged<AnyObject>.fromOpaque)?.release()
                __os_activity_end(state.opaque.1)
            }
            
        }
    }
    
    /// Changes the current execution context to the activity.
    ///
    /// An activity can be created and applied to the current scope by doing:
    ///
    ///    var scope = OSActivity("my new activity").enter()
    ///    defer { scope.leave() }
    ///    ... do some work ...
    ///
    internal func enter() -> Scope {
        var scope = Scope()
        if #available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) {
            _os_activity_scope_enter(opaque, &scope.state)
        } else {
            let context = opaque as! LegacyActivityContext
            scope.state.opaque.0 = numericCast(Int(bitPattern: Unmanaged.passRetained(context).toOpaque()))
            scope.state.opaque.1 = __os_activity_start(context.dsoHandle, context.description, context.flags)
        }
        return scope
    }
    
    /// Creates an activity.
    @available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
    internal init(_ description: StaticString, dso: UnsafeRawPointer? = #dsohandle, parent: Activity, options: Options = []) {
        self.opaque = description.withUTF8Buffer { (buf: UnsafeBufferPointer<UInt8>) -> AnyObject in
            let str = buf.baseAddress!.withMemoryRebound(to: Int8.self, capacity: 8, { $0 })
            let flags = os_activity_flag_t(rawValue: options.rawValue)
            return _os_activity_create(dso, str, Unmanaged.passRetained(parent.opaque), flags)
        }
    }
    
    private init(_ opaque: AnyObject) {
        self.opaque = opaque
    }
    
    /// An activity with no traits; as a parent, it is equivalent to a
    /// detached activity.
    @available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
    internal static var none: Activity {
        return Activity(OS_ACTIVITY_NONE.takeUnretainedValue())
    }
    
    /// The running activity.
    ///
    /// As a parent, the new activity is linked to the current activity, if one
    /// is present. If no activity is present, it behaves the same as `.none`.
    @available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
    internal static var current: Activity {
        return Activity(OS_ACTIVITY_CURRENT.takeUnretainedValue())
    }
    
    /// Label an activity auto-generated by UI with a name that is useful for
    /// debugging macro-level user actions.
    ///
    /// This function should be called early within the scope of an `IBAction`,
    /// before any sub-activities are created. The name provided will be shown
    /// in tools in addition to the system-provided name. This API should only
    /// be called once, and only on an activity created by the system. These
    /// actions help determine workflow of the user in order to reproduce
    /// problems that occur.
    ///
    /// For example, a control press and/or menu item selection can be labeled:
    ///
    ///    OSActivity.labelUserAction("New mail message")
    ///    OSActivity.labelUserAction("Empty trash")
    ///
    /// Where the underlying name will be "gesture:" or "menuSelect:".
    @available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
    internal static func labelUserAction(_ description: StaticString, dso: UnsafeRawPointer? = #dsohandle) {
        description.withUTF8Buffer { (buf: UnsafeBufferPointer<UInt8>) in
            let str = buf.baseAddress!.withMemoryRebound(to: Int8.self, capacity: 8, { $0 })
            _os_activity_label_useraction(UnsafeMutableRawPointer(mutating: dso!), str)
        }
    }
    
}
