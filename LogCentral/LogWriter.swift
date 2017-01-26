//
//  LogWriter.swift
//  LogCentral
//
//  Created by Henrik Akesson on 13/12/16.
//  Copyright © 2016 Henrik Akesson. All rights reserved.
//

import Foundation


public typealias LogWrite = (_ message: String, _ level: LogLevel) -> Void

public protocol LoggerSpec {
    var levels: [LogLevel] { get }
    var writer: LogWrite { get }
}

public struct LogWriter: LoggerSpec {
    public let levels: [LogLevel]
    public let writer: LogWrite
    
    public init(levels: [LogLevel], writer: @escaping LogWrite) {
        self.levels = levels
        self.writer = writer
    }
}
