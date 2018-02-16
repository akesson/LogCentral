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

public protocol IntConvertible {
    var rawValue: Int { get }
    var name: String { get }
}

public protocol CategorySpec: IntConvertible {
    static var asArray: [Self] { get }
}

/**
 The loggers here are custom loggers that specifies
 the log level they are listening to. For those they
 will be called each time a log is made. This variable
 is global for the LogCentral framework.
 
 The LogLevels that this logger receives depends on
 the logger created. Ie:
 - LogCentral3Lvl: debug, error, info
 - LogCentral4Lvl: debug, error, info, default
 - LogCentral5Lvl: debug, error, info, default, fatal
 */
public var loggers = [LoggerSpec]()

/// A LogCentral with the log levels: debug, error, info
public class LogCentral3Lvl<T: CategorySpec> {
    fileprivate let logManager: LogManager<T>
    
    public init(subsystem: String) {
        logManager = LogManager(subsystem: subsystem, categories: T.asArray)
    }
    
    // MARK: - Info level logging

    ///Info level is for messages that will be helpful for troubleshooting an error
    public final func info<M>(in category: T,
                              dso: UnsafeRawPointer? = #dsohandle,
                              file:String = #file,
                              line:Int = #line,
                              function:String = #function,
                              _ message: M) where M: CustomStringConvertible {
        
        let origin = Log.Origin(dso, file, line, function)
        logManager.log(category: category, origin: origin, level: .info, message.description)
    }

    public final func info(in category: T,
                           dso: UnsafeRawPointer? = #dsohandle,
                           file: String = #file,
                           line: Int = #line,
                           function: String = #function,
                           _ message: Any) {

        let origin = Log.Origin(dso, file, line, function)
        logManager.log(category: category, origin: origin, level: .info, String(reflecting: message))
    }

    // MARK: - Debug level logging
    
    public final func debug<M>(in category: T,
                               dso: UnsafeRawPointer? = #dsohandle,
                               file: String = #file,
                               line: Int = #line,
                               function: String = #function,
                               _ message: M) where M: CustomStringConvertible {
        
        let origin = Log.Origin(dso, file, line, function)
        logManager.log(category: category, origin: origin, level: .debug, message.description)
    }
    
    public final func debug(in category: T,
                            dso: UnsafeRawPointer? = #dsohandle,
                            file: String = #file,
                            line: Int = #line,
                            function: String = #function,
                            _ message: Any) {
        
        let origin = Log.Origin(dso, file, line, function)
        logManager.log(category: category, origin: origin, level: .debug, String(reflecting: message))
    }
    // MARK: - Error logging
    
    public final func error<M>(in category: T,
                               dso: UnsafeRawPointer? = #dsohandle,
                               file: String = #file,
                               line: Int = #line,
                               function: String = #function,
                               _ message: M?) where M: CustomStringConvertible {

        let origin = Log.Origin(dso, file, line, function)

        if let message = message {
            let error = NSError(domain: logManager.subsystem,
                                code: 0,
                                userInfo: [NSLocalizedDescriptionKey: message.description])
            logManager.log(category: category, origin: origin, message.description, error)
        } else {
            logManager.nilError(category: category, origin: origin)
        }
    }

    public final func error(in category: T,
                            dso: UnsafeRawPointer? = #dsohandle,
                            file: String = #file,
                            line: Int = #line,
                            function: String = #function,
                            _ object: Any?) {
        
        let origin = Log.Origin(dso, file, line, function)

        if let object = object {
            let message = String(reflecting: object)
            let error = NSError(domain: logManager.subsystem,
                                code: 0,
                                userInfo: [NSLocalizedDescriptionKey: message])
            logManager.log(category: category, origin: origin, String(reflecting: message), error)
        } else {
            logManager.nilError(category: category, origin: origin)
        }
    }

    public final func error(in category: T,
                            dso: UnsafeRawPointer? = #dsohandle,
                            file: String = #file,
                            line: Int = #line,
                            function: String = #function,
                            _ error: NSError?) {
        
        let origin = Log.Origin(dso, file, line, function)
        
        if let error = error {
            let message = error.localizedDescription
            logManager.log(category: category, origin: origin, message, error)
        } else {
            logManager.nilError(category: category, origin: origin)
        }
    }

    public final func error<E>(in category: T,
                               dso: UnsafeRawPointer? = #dsohandle,
                               file: String = #file,
                               line: Int = #line,
                               function: String = #function,
                               _ error: E?) where E: Error {
        
        let origin = Log.Origin(dso, file, line, function)

        if let error = error {
            let message = error.localizedDescription
            logManager.log(category: category, origin: origin, message, error)
        } else {
            logManager.nilError(category: category, origin: origin)
        }
    }
    
    // MARK: - Activity logging
    
    /**
     An internal activity, typically used for splitting the work into
     logical segments like "searching database", "filtering results",
     "updating ui". Will be nested inside of any previous activities,
     if any.
     */
    public final func activity<T>(dso: UnsafeRawPointer? = #dsohandle,
                                  _ description: StaticString,
                                  _ body: () throws -> T) rethrows -> T {
        
        return try logManager.activity(dso, description, body)
    }

    /**
     Normally a user initiated activity (button click etc.) or an
     externally triggered event typically originating from the OS
     by events like CoreData change, Photos change.
     Starts a new top level activity in the console.
     */
    public final func rootActivity<T>(dso: UnsafeRawPointer? = #dsohandle,
                                      _ description: StaticString,
                                      _ body: () throws -> T) rethrows -> T {
        
        return try logManager.rootActivity(dso, description, body)
    }
}

/// A LogCentral with the log levels: debug, error, info, default
public class LogCentral4Lvl<T: CategorySpec>: LogCentral3Lvl<T> {
    
    // MARK: - Default level logging
    
    ///Default level is for messages about things that might cause a failure
    public final func `default`<M>(in logSpec: T,
                                   dso: UnsafeRawPointer? = #dsohandle,
                                   file:String = #file,
                                   line:Int = #line,
                                   function:String = #function,
                                   _ message: M) where M: CustomStringConvertible {
        
        let origin = Log.Origin(dso, file, line, function)
        logManager.log(category: logSpec, origin: origin, level: .default, message.description)
    }

    ///Default level is for messages about things that might cause a failure
    public final func `default`(in logSpec: T,
                                dso: UnsafeRawPointer? = #dsohandle,
                                file: String = #file,
                                line: Int = #line,
                                function: String = #function,
                                _ object: Any) {
        
        let origin = Log.Origin(dso, file, line, function)
        logManager.log(category: logSpec, origin: origin, level: .default, String(reflecting: object))
    }
}

/// A LogCentral with the log levels: debug, error, info, default, fault
public class LogCentral5Lvl<T: CategorySpec>: LogCentral4Lvl<T> {
    
    // MARK: - Fault level logging

    public final func fault<M>(in category: T,
                               dso: UnsafeRawPointer? = #dsohandle,
                               file: String = #file,
                               line: Int = #line,
                               function: String = #function,
                               _ message: M) where M: CustomStringConvertible {
        
        let origin = Log.Origin(dso, file, line, function)
        logManager.log(category: category, origin: origin, level: .fault, message.description)
    }

    public final func fault(in category: T,
                            dso: UnsafeRawPointer? = #dsohandle,
                            file: String = #file,
                            line: Int = #line,
                            function: String = #function,
                            _ object: Any) {
        
        let origin = Log.Origin(dso, file, line, function)
        logManager.log(category: category, origin: origin, level: .fault, String(reflecting: object))
    }
}
