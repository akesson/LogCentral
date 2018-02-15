//
//  TestLogger.swift
//  LogCentralTests
//
//  Created by Henrik Akesson on 15/02/2018.
//  Copyright © 2018 Henrik Akesson. All rights reserved.
//

import Foundation
import LogCentral

class TestLogger: LoggerSpec {
    var messageWriter: LogMessageWriter = { _, _ in }
    var errorObjectWriter: LogErrorObjectWriter?
    let levels: [LogLevel]
    
    var lastLog: (level: LogLevel, message: String)?
    var lastError: Error?
    
    var last: String {
        if let error = lastError {
            return error.localizedDescription
        } else if let log = lastLog {
            return "[\(log.level)] \(log.message)"
        } else {
            return "Nothing logged"
        }
    }
    
    init(_ levels: [LogLevel]) {
        self.levels = levels
        errorObjectWriter = { error in
            self.lastLog = nil
            self.lastError = error
        }
        messageWriter = { message, level in
            self.lastLog = (level, message)
            self.lastError = nil
        }
    }
}
