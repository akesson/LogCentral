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
    private let crashlogger: LogWriter?
    
    init(subsystem: String, categories: [T], crashlogger: LogWriter?) {
        self.osLoggers = OsLoggers(categories, subsystem: subsystem)
        self.crashlogger = crashlogger
    }
    
    init(subsystem: String, categories: [T]) {
        self.init(subsystem: subsystem, categories: categories, crashlogger: nil)
    }
    
    func activity(for activity: U, in category: T, dso: UnsafeRawPointer?, _ description: StaticString, _ body: () -> Void) {
        crashlog(.info, description)
        
        let options: Activity.Options = activity.isTopLevel ? .detached : []
        var scope = Activity(description, dso: dso, options: options).enter()
        body()
        scope.leave()
    }
    
    func log(category: T, dso: UnsafeRawPointer?, level: Level, _ message: StaticString, _ args: CVarArg...) {
        let messageString = LazyString(message: message, args)
        
        console(messageString, category: category, dso: dso, level: level)
        
        if level != .debug {
            crashlog(level, messageString)
        }
    }
    
    private func console(_ message: LazyString, category: T, dso: UnsafeRawPointer?, level lvl: Level) {
        if #available(iOS 10.0, *), let args = message.args {
            os_log(message.message, dso: dso, log: osLoggers.osLog(for: category), type: lvl.osLogType, args)
        } else {
            print(message)
        }
    }
    
    private func crashlog(_ level: Level, _ message: CustomStringConvertible) {
        if let crashlogger = crashlogger {
            crashlogger(message.description, level)
        }
    }
}
