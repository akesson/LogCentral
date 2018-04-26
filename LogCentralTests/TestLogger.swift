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
    var messageWriter: LogMessageWriter = { _ in }
    var errorObjectWriter: LogErrorObjectWriter?
    let levels: [LogLevel]
    
    var lastLog: Log?
    var lastError: Error?
    
    var last: String {
        if let error = lastError {
            return error.localizedDescription
        } else if let log = lastLog { 
            return "[\(log.level) - \(log.category.name)] \(log.message)"
        } else {
            return "Nothing logged"
        }
    }
    
    init(_ levels: [LogLevel]) {
        self.levels = levels
        errorObjectWriter = { error, origin in
            self.lastLog = nil
            self.lastError = error
        }
        messageWriter = { log in
            self.lastLog = log
            self.lastError = nil
        }
    }
}
