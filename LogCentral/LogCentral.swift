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

public protocol CategorySpec {
    var rawValue: Int { get }
    
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

    ///Info level is for messages about things that will be helpful for troubleshooting an error
    public final func info(in category: T,
                           dso: UnsafeRawPointer? = #dsohandle,
                           file:String = #file,
                           line:Int = #line,
                           function:String = #function,
                           _ message: String) {
        logManager.log(category: category, dso: dso, level: .info, message)
    }
    
    public final func debug(in category: T,
                            dso: UnsafeRawPointer? = #dsohandle,
                            file:String = #file,
                            line:Int = #line,
                            function:String = #function,
                            _ message: String) {
        logManager.log(category: category, dso: dso, level: .debug, message)
    }
    
    public final func error(in category: T,
                            dso: UnsafeRawPointer? = #dsohandle,
                            file:String = #file,
                            line:Int = #line,
                            function:String = #function,
                            _ message: String) {
        let error = NSError(domain: "logcentral", code: 0, userInfo: [NSLocalizedDescriptionKey : message])
        logManager.log(category: category, dso: dso, message, error)
    }

    public final func error(in category: T,
                            dso: UnsafeRawPointer? = #dsohandle,
                            file:String = #file,
                            line:Int = #line,
                            function:String = #function,
                            _ message: String,
                            _ error: NSError) {
        
        logManager.log(category: category, dso: dso, message, error)
    }

    public final func error(in category: T,
                            dso: UnsafeRawPointer? = #dsohandle,
                            file:String = #file,
                            line:Int = #line,
                            function:String = #function,
                            _ error: NSError) {
        let message = error.localizedDescription
         logManager.log(category: category, dso: dso, message, error)
    }

    /**
     An internal activity, typically used for splitting the work into
     logical segments like "searching database", "filtering results",
     "updating ui". Will be nested inside of any previous activities,
     if any.
     */
    public final func activity<T>(dso: UnsafeRawPointer? = #dsohandle,
                                  file:String = #file,
                                  line:Int = #line,
                                  function:String = #function,
                                  _ description: StaticString,
                                  _ body: () throws -> T) rethrows -> T {
        
        return try logManager.activity(dso: dso, description, body)
    }
    
    /**
     Normally a user initiated activity (button click etc.) or an
     externally triggered event typically originating from the OS
     by events like CoreData change, Photos change.
     Starts a new top level activity in the console.
     */
    public final func rootActivity<T>(dso: UnsafeRawPointer? = #dsohandle,
                                      file:String = #file,
                                      line:Int = #line,
                                      function:String = #function,
                                      _ description: StaticString,
                                      _ body: () throws -> T) rethrows -> T {
        
        return try logManager.activity(dso: dso, description, body)
    }
}

/// A LogCentral with the log levels: debug, error, info, default
public class LogCentral4Lvl<T: CategorySpec>: LogCentral3Lvl<T> {
    ///Default level is for messages about things that might cause a failure
    public final func `default`(in logSpec: T,
                                dso: UnsafeRawPointer? = #dsohandle,
                                _ message: String) {
        
        logManager.log(category: logSpec, dso: dso, level: .default, message)
    }
}
/// A LogCentral with the log levels: debug, error, info, default, fault
public class LogCentral5Lvl<T: CategorySpec>: LogCentral4Lvl<T> {
    public final func fault(in category: T,
                            dso: UnsafeRawPointer? = #dsohandle,
                            _ message: String) {
        
        logManager.log(category: category, dso: dso, level: .fault, message)
    }
}
