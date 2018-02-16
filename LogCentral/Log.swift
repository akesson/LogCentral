//
//  Log.swift
//  LogCentral
//
//  Created by Henrik Akesson on 15/02/2018.
//  Copyright © 2018 Henrik Akesson. All rights reserved.
//

import Foundation

public struct Log {
    public let origin: Origin
    public let message: String
    public let category: IntConvertible
    public let level: LogLevel
    
    public var consoleFormattedMessage: String {
        return "\(origin.logPrefix) \(message)"
    }
    
    public var formattedMessage: String {
        return "[\(level)] \(origin.logPrefix) \(message)"
    }
    
    init(_ origin: Log.Origin, _ category: IntConvertible, _ level: LogLevel, _ message: String) {
        self.origin = origin
        self.category = category
        self.message = message
        self.level = level
    }
}

extension Log {
    public struct Origin {
        let dso: UnsafeRawPointer?
        public let file: String
        public let line: Int
        public let function: String
        
        public var filename: String? {
            guard let fileNameAndEnding = file.split(separator: "/").last else {
                return nil
            }
            return fileNameAndEnding.replacingOccurrences(of: ".swift", with: "")
        }
        
        ///format: "filename:line"
        public var logPrefix: String {
            return "\(filename ?? file):\(line)"
        }
        
        init(_ dso: UnsafeRawPointer?, _ file: String, _ line: Int, _ function: String) {
            self.dso = dso
            self.file = file
            self.line = line
            self.function = function
        }
    }
}

extension Log: CustomStringConvertible {
    public var description: String {
        return formattedMessage
    }
}
