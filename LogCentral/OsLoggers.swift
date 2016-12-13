//
//  OsLoggers.swift
//  LogCentral
//
//  Created by Henrik Akesson on 13/12/16.
//  Copyright © 2016 Henrik Akesson. All rights reserved.
//

import Foundation
import os.log

struct OsLoggers<T: LoggerSpec> {
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
