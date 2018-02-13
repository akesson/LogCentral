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

public protocol ActivitySpec {
    var isTopLevel: Bool { get }
}

public class LogCentral3Lvl<T: CategorySpec, U: ActivitySpec> {
    fileprivate let logManager: LogManager<T, U>
    
    public init(subsystem: String, loggers: [LoggerSpec]) {
        logManager = LogManager(subsystem: subsystem, categories: T.asArray, loggers: loggers)
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

    public final func activity<T>(for type: U,
                                  dso: UnsafeRawPointer? = #dsohandle,
                                  file:String = #file,
                                  line:Int = #line,
                                  function:String = #function,
                                  _ description: StaticString,
                                  _ body: () throws -> T) rethrows -> T {
        
        return try logManager.activity(for: type, dso: dso, description, body)
    }    
}

public class LogCentral4Lvl<T: CategorySpec, U: ActivitySpec>: LogCentral3Lvl<T, U> {
    ///Default level is for messages about things that might cause a failure
    public final func `default`(in logSpec: T,
                                dso: UnsafeRawPointer? = #dsohandle,
                                _ message: String) {
        
        logManager.log(category: logSpec, dso: dso, level: .default, message)
    }
}

public class LogCentral5Lvl<T: CategorySpec, U: ActivitySpec>: LogCentral4Lvl<T, U> {
    public final func fault(in category: T,
                            dso: UnsafeRawPointer? = #dsohandle,
                            _ message: String) {
        
        logManager.log(category: category, dso: dso, level: .fault, message)
    }
}

