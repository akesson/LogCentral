//
//  LogWriter.swift
//  LogCentral
//
//  Created by Henrik Akesson on 13/12/16.
//  Copyright © 2016 Henrik Akesson. All rights reserved.
//

import Foundation


public typealias LogMessageWriter = (_ message: String, _ level: LogLevel) -> Void
public typealias LogErrorObjectWriter = (_ error: NSError) -> Void

public protocol LoggerSpec {
    var levels: [LogLevel] { get }
    var messageWriter: LogMessageWriter { get }
    var errorObjectWriter: LogErrorObjectWriter? { get }
}

public struct LogWriter: LoggerSpec {
    public let levels: [LogLevel]
    public let messageWriter: LogMessageWriter
    public let errorObjectWriter: LogErrorObjectWriter?
    
    public init(levels: [LogLevel], messageWriter: @escaping LogMessageWriter, errorObjectWriter: LogErrorObjectWriter?) {
        self.levels = levels
        self.messageWriter = messageWriter
        self.errorObjectWriter = errorObjectWriter
    }
}
