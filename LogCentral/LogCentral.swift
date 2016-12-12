//
//  LogCentral.swift
//  LogCentral
//
//  Created by Henrik Akesson on 3/12/16.
//  Copyright © 2016 Henrik Akesson. All rights reserved.
//

import Foundation
import os.log
import os.activity

public typealias LogWriter = (_ message: String) -> Void

public protocol LoggerSpec {
    var rawValue: Int { get }
}

private enum Level {
    case info, debug, `default`, error, fault
    
    @available(iOS 10.0, *)
    var osLogType: OSLogType {
        switch self {
        case .debug:
            return OSLogType.debug
        case .default:
            return OSLogType.default
        case .error:
            return OSLogType.error
        case .fault:
            return OSLogType.fault
        case .info:
            return OSLogType.info
        }
    }
}

private final class LazyString: CustomStringConvertible {
    let message:StaticString
    let args:CVarArg?
    
    private var _string: String?
    var description: String {
        if let _string = _string {
            return _string
        }
        if let args = args {
            _string = String(format: message.description, args)
        } else {
            _string = String(describing: message)
        }
        return _string!
    }
    
    init(message: StaticString, _ args: CVarArg...) {
        self.message = message
        self.args = args
    }
    
    init(message: StaticString) {
        self.message = message
        self.args = nil
    }
}

private struct OsLoggers<T: LoggerSpec> {
    private let osLoggers:[OSLog]
    
    init(_ loggers: [T], subsystem: String) {
        var osLoggers = [OSLog]()
        if #available(iOS 10.0, *) {
            for logger in loggers {
                let log = OSLog(subsystem: subsystem, category: "\(logger)")
                osLoggers.insert(log, at: logger.rawValue)
            }
        } //not used for non supported versions of os
        self.osLoggers = osLoggers
    }
    
    func osLog(for log: LoggerSpec) -> OSLog {
        assert(osLoggers.count > log.rawValue, "Please configure the loggers before using them")
        return osLoggers[log.rawValue]
    }
}

public struct LogCentral<T: LoggerSpec> {
    private let osLoggers: OsLoggers<T>
    private let crashlogger: LogWriter?

    init(subsystem: String, loggers: [T], crashlogger: LogWriter?) {
        self.osLoggers = OsLoggers(loggers, subsystem: subsystem)
        self.crashlogger = crashlogger
    }
    
    init(subsystem: String, loggers: [T]) {
        self.init(subsystem: subsystem, loggers: loggers, crashlogger: nil)
    }
    
    public func activity(for type: Activities, in logSpec: T, dso: UnsafeRawPointer? = #dsohandle, _ description: StaticString, _ body: () -> Void) {
        crashlog(description)
        
        let options: Activity.Options = type.topLevel ? .detached : []
        var scope = Activity(description, dso: dso, options: options).enter()
        body()
        scope.leave()
    }
    
    ///Default level is for messages about things that might cause a failure
    public func `default`(in logSpec: T, dso: UnsafeRawPointer? = #dsohandle, _ message: StaticString, _ args: CVarArg...) {
        log(log: logSpec, type: .default, message, args)
    }
    
    ///Info level is for messages about things that will be helpful for troubleshooting an error
    public func info(in logSpec: T, dso: UnsafeRawPointer? = #dsohandle, _ message: StaticString, _ args: CVarArg...) {
        log(log: logSpec, type: .info, message, args)
    }

    public func debug(in logSpec: T, dso: UnsafeRawPointer? = #dsohandle, _ message: StaticString, _ args: CVarArg...) {

        log(log: logSpec, type: .debug, message, args)
    }

    private func log(log: T, dso: UnsafeRawPointer? = #dsohandle, type: Level, _ message: StaticString, _ args: CVarArg...) {
        let messageString = LazyString(message: message, args)
        
        console(messageString, log: log, dso: dso, type: type)
        
        if type != .debug {
            crashlog(messageString)
        }
    }

    private func console(_ message: LazyString, log: T, dso: UnsafeRawPointer? = #dsohandle, type: Level) {
        if #available(iOS 10.0, *), let args = message.args {
            os_log(message.message, dso: dso, log: osLoggers.osLog(for: log), type: type.osLogType, args)
        } else {
            print(message)
        }
    }
    
    private func crashlog(_ message: CustomStringConvertible) {
        if let crashlogger = crashlogger {
            crashlogger(message.description)
        }
    }
}
