//
//  LogManager.swift
//  LogCentral
//
//  Created by Henrik Akesson on 13/12/16.
//  Copyright © 2016 Henrik Akesson. All rights reserved.
//

import Foundation
import os.log

struct LogManager<T: CategorySpec, U: ActivitySpec> {
    private let osLoggers: OsLoggers<T>
    private let loggers: [LoggerSpec]
    
    init(subsystem: String, categories: [T], loggers: [LoggerSpec]) {
        self.osLoggers = OsLoggers(categories, subsystem: subsystem)
        self.loggers = loggers
    }
    
    func activity(for activity: U, in category: T, dso: UnsafeRawPointer?, _ description: StaticString, _ body: () -> Void) {
        
        let options: Activity.Options = activity.isTopLevel ? .detached : []
        var scope = Activity(description, dso: dso, options: options).enter()
        body()
        scope.leave()
    }
    
    func log(category: T, dso: UnsafeRawPointer?, level: LogLevel, _ message: StaticString, _ args: CVarArg...) {
        let messageString = LazyString(message, args)
        
        toConsole(messageString, category: category, dso: dso, level: level)
        toLoggers(messageString, level: level)
    }
    
    func toLoggers(_ lvl: LogLevel, _ message: String) {
        toLoggers(LazyString(message), level: lvl)
    }
    
    private func toLoggers(_ message: LazyString, level lvl: LogLevel) {
        for logger in loggers {
            for levels in logger.levels {
                if levels == lvl {
                    logger.writer(message.description, lvl)
                }
            }
        }
    }
    
    private func toConsole(_ message: LazyString, category: T, dso: UnsafeRawPointer?, level lvl: LogLevel) {
        if #available(iOS 10.0, *), let args = message.args {
            os_log(message.message, dso: dso, log: osLoggers.osLog(for: category), type: lvl.osLogType, args)
        } else {
            print(message)
        }
    }
}
