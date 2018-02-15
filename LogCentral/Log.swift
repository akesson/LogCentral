//
//  Log.swift
//  LogCentral
//
//  Created by Henrik Akesson on 15/02/2018.
//  Copyright © 2018 Henrik Akesson. All rights reserved.
//

import Foundation

private extension String {
    init?(_ subSequence: String.SubSequence?) {
        guard let subSequence = subSequence else {
            return nil
        }
        self.init(subSequence)
    }
}

struct Log {
    let origin: Origin
    let message: String
    let category: IntConvertible
    let level: LogLevel
    
    var consoleFormattedMessage: String {
        return "\(origin.logPrefix) \(message)"
    }
    
    var formattedMessage: String {
        return "[\(level)] \(origin.logPrefix)"
    }
    
    init(_ origin: Log.Origin, _ category: IntConvertible, _ level: LogLevel, _ message: String) {
        self.origin = origin
        self.category = category
        self.message = message
        self.level = level
    }
}

extension Log {
    struct Origin {
        let dso: UnsafeRawPointer?
        let file: String
        let line: Int
        let function: String
        
        ///format: "filename:line"
        let logPrefix: String
        
        init(_ dso: UnsafeRawPointer?, _ file: String, _ line: Int, _ function: String) {
            self.dso = dso
            self.file = file
            self.line = line
            self.function = function
            
            if let fileNameAndEnding = file.split(separator: "/").last {
                let fileName = fileNameAndEnding.replacingOccurrences(of: ".swift", with: "")
                logPrefix = "\(fileName):\(line)"
            } else {
                logPrefix = "\(function):\(line)"
            }
        }
    }
}
