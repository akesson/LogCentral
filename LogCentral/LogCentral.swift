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

public protocol ActivitySpec {
    var isTopLevel: Bool { get }
}

public class LogCentral3Lvl<T: LoggerSpec, U: ActivitySpec> {
    fileprivate let logManager: LogManager<T, U>
    
    init(subsystem: String, loggers: [T]) {
        logManager = LogManager(subsystem: subsystem, loggers: loggers)
    }

    ///Info level is for messages about things that will be helpful for troubleshooting an error
    public final func info(in logSpec: T, dso: UnsafeRawPointer? = #dsohandle, _ message: StaticString, _ args: CVarArg...) {
        logManager.log(log: logSpec, dso: dso, type: .info, message, args)
    }
    
    public final func debug(in logSpec: T, dso: UnsafeRawPointer? = #dsohandle, _ message: StaticString, _ args: CVarArg...) {
        logManager.log(log: logSpec, dso: dso, type: .debug, message, args)
    }
    
    public final func error(in logSpec: T, dso: UnsafeRawPointer? = #dsohandle, _ message: StaticString, _ args: CVarArg...) {
        logManager.log(log: logSpec, dso: dso, type: .error, message, args)
    }
    
    public final func activity(for type: U, in logSpec: T, dso: UnsafeRawPointer? = #dsohandle, _ description: StaticString, _ body: () -> Void) {
        logManager.activity(for: type, in: logSpec, dso: dso, description, body)
    }
}

public class LogCentral4Lvl<T: LoggerSpec, U: ActivitySpec>: LogCentral3Lvl<T, U> {
    ///Default level is for messages about things that might cause a failure
    public final func `default`(in logSpec: T, dso: UnsafeRawPointer? = #dsohandle, _ message: StaticString, _ args: CVarArg...) {
        logManager.log(log: logSpec, dso: dso, type: .default, message, args)
    }
}

public class LogCentral5Lvl<T: LoggerSpec, U: ActivitySpec>: LogCentral4Lvl<T, U> {
    public final func fault(in logSpec: T, dso: UnsafeRawPointer? = #dsohandle, _ message: StaticString, _ args: CVarArg...) {
        logManager.log(log: logSpec, dso: dso, type: .fault, message, args)
    }
}

