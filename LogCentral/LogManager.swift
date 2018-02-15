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
        let log = Log(origin, category, .error, message)
        toConsole(log)
        toLoggers(log)
        LogCentral.loggers.filter { $0.levels.contains(.error) }.forEach { (logger) in
            logger.errorObjectWriter?(error)
        }
    }
    
    //log when error object = nil
    func nilError(category: T, origin: Log.Origin) {
        let message = "The operation couldn’t be completed. (error object was nil)"
        let log = Log(origin, category, .error, message)
        self.log(log)
    }
    
    //log messages
    
    func log(category: T, origin: Log.Origin, level: LogLevel, _ message: String) {
        let log = Log(origin, category, level, message)
        self.log(log)
    }
    
    func log(_ log: Log) {
        toConsole(log)
        toLoggers(log)
    }
    
    private func toLoggers(_ log: Log) {
        LogCentral.loggers.filter { $0.levels.contains(log.level) }.forEach { (logger) in
            logger.messageWriter(log)
        }
    }
    
    private func toConsole(_ log: Log) {
        if #available(iOS 10.0, *) {
            os_log("%@", dso: log.origin.dso, log: osLoggers.osLog(for: log.category), type: log.level.osLogType, log.consoleFormattedMessage)
        } else {
            print(log.message)
        }
    }
}
