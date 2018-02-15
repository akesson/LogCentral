//
//  LogManager.swift
//  LogCentral
//
//  Created by Henrik Akesson on 13/12/16.
//  Copyright © 2016 Henrik Akesson. All rights reserved.
//

import Foundation
import os.log

struct LogManager<T: CategorySpec> {
    private let osLoggers: OsLoggers
    let subsystem: String
    
    init<T: CategorySpec>(subsystem: String, categories: [T]) {
        self.subsystem = subsystem
        self.osLoggers = OsLoggers(categories, subsystem: subsystem)
    }

    func activity<T>(_ dso: UnsafeRawPointer?, _ description: StaticString, _ body: () throws -> T) rethrows -> T {
        
        var scope = Activity(description, dso: dso).enter()
        defer {
            scope.leave()
        }
        return try body()
    }

    func rootActivity<T>(_ dso: UnsafeRawPointer?, _ description: StaticString, _ body: () throws -> T) rethrows -> T {
        
        var scope = Activity(description, dso: dso, options: .detached).enter()
        defer {
            scope.leave()
        }
        return try body()
    }

    //log errors
    func log(category: T, origin: Log.Origin, _ message: String, _ error: Error) {
        toConsole(message, category: category, origin: origin, level: .error)
        toLoggers(message, level: .error)
        LogCentral.loggers.filter { $0.levels.contains(.error) }.forEach { (logger) in
            logger.errorObjectWriter?(error)
        }
    }
    
    //log when error object = nil
    func nilError(category: T, origin: Log.Origin) {
        let message = origin.logPrefix + " The operation couldn’t be completed. (error object was nil)"
        self.log(category: category, origin: origin, level: .error, message)
    }
    
    //log messages
    func log(category: T, origin: Log.Origin, level: LogLevel, _ message: String) {
        toConsole(message, category: category, origin: origin, level: level)
        toLoggers(message, level: level)
    }
    
    private func toLoggers(_ message: String, level lvl: LogLevel) {
        LogCentral.loggers.filter { $0.levels.contains(lvl) }.forEach { (logger) in
            logger.messageWriter(message, lvl)
        }
    }
    
    private func toConsole(_ message: String, category: T, origin: Log.Origin, level lvl: LogLevel) {
        if #available(iOS 10.0, *) {
            os_log("%@", dso: origin.dso, log: osLoggers.osLog(for: category), type: lvl.osLogType, message)
        } else {
            print(message)
        }
    }
}
