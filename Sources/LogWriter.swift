//
//  LogWriter.swift
//  LogCentral
//
//  Created by Henrik Akesson on 15/02/2018.
//  Copyright © 2018 Henrik Akesson. All rights reserved.
//

public struct LogWriter: LoggerSpec {
    
    public let levels: [LogLevel]
    public let messageWriter: LogMessageWriter
    public let errorObjectWriter: LogErrorObjectWriter?
    
    public init(levels: [LogLevel]? = nil,
                _ messageWriter: @escaping LogMessageWriter,
                errorObjectWriter: LogErrorObjectWriter? = nil) {
        
        self.levels = levels ?? [.debug, .default, .error, .fault, .info]
        self.messageWriter = messageWriter
        self.errorObjectWriter = errorObjectWriter
    }
}
