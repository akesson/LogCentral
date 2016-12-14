//
//  LogObjcWrapper.swift
//  LogCentral
//
//  Created by Henrik Akesson on 14/12/16.
//  Copyright © 2016 Henrik Akesson. All rights reserved.
//

import Foundation

@objc public class LogObjcWrapper: NSObject {
    private let logger: ObjCLogger
    
    public init<T, U>(logger: LogCentral<T, U>) {
        self.logger = logger
    }
    
    @objc public final func toLoggers(_ lvl: LogLevel, _ message: String) {
        
        
    }
}
