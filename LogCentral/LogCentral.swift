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
}

public protocol ActivitySpec {
    var isTopLevel: Bool { get }
}

public class LogCentral3Lvl<T: CategorySpec, U: ActivitySpec> {
    fileprivate let logManager: LogManager<T, U>
    
    public init(subsystem: String, categories: [T], loggers: [LoggerSpec]) {
        logManager = LogManager(subsystem: subsystem, categories: categories, loggers: loggers)
    }

    ///Info level is for messages about things that will be helpful for troubleshooting an error
    public final func info(in category: T,
                           dso: UnsafeRawPointer? = #dsohandle,
                           file:String = #file,
                           line:Int = #line,
                           function:String = #function,
                           _ message: StaticString,
                           _ args: CVarArg...) {
        logManager.log(category: category, dso: dso, level: .info, message, args)
    }
    
    public final func debug(in category: T,
                            dso: UnsafeRawPointer? = #dsohandle,
                            file:String = #file,
                            line:Int = #line,
                            function:String = #function,
                            _ message: StaticString,
                            _ args: CVarArg...) {
        logManager.log(category: category, dso: dso, level: .debug, message, args)
    }
    
    public final func error(in category: T,
                            dso: UnsafeRawPointer? = #dsohandle,
                            file:String = #file,
                            line:Int = #line,
                            function:String = #function,
                            _ message: StaticString,
                            _ args: CVarArg...) {
        logManager.log(category: category, dso: dso, level: .error, message, args)
    }
    
    public final func activity(for type: U,
                               in category: T,
                               dso: UnsafeRawPointer? = #dsohandle,
                               file:String = #file,
                               line:Int = #line,
                               function:String = #function, 
                               _ description: StaticString,
                               _ body: () -> Void) {
        
        logManager.activity(for: type, in: category, dso: dso, description, body)
    }
    
    public final func activity(for type: U,
                               in category: T,
                               dso: UnsafeRawPointer? = #dsohandle,
                               file:String = #file,
                               line:Int = #line,
                               function:String = #function,
                               _ body: () -> Void) {
        
        
    }
}

public class LogCentral4Lvl<T: CategorySpec, U: ActivitySpec>: LogCentral3Lvl<T, U> {
    ///Default level is for messages about things that might cause a failure
    public final func `default`(in logSpec: T,
                                dso: UnsafeRawPointer? = #dsohandle,
                                _ message: StaticString,
                                _ args: CVarArg...) {
        
        logManager.log(category: logSpec, dso: dso, level: .default, message, args)
    }
}

public class LogCentral5Lvl<T: CategorySpec, U: ActivitySpec>: LogCentral4Lvl<T, U> {
    public final func fault(in category: T,
                            dso: UnsafeRawPointer? = #dsohandle,
                            _ message: StaticString,
                            _ args: CVarArg...) {
        
        logManager.log(category: category, dso: dso, level: .fault, message, args)
    }
}

