//
//  LogObjcWrapper.swift
//  LogCentral
//
//  Created by Henrik Akesson on 14/12/16.
//  Copyright © 2016 Henrik Akesson. All rights reserved.
//

import Foundation

@objc class LogObjcWrapper: NSObject {
    private let logger: ObjCLogger
    
    init(logger: ObjCLogger) {
        self.logger = logger
    }
    
    @objc public final func toLoggers(_ lvl: LogLevel, _ message: String) {
        
        
    }
}
