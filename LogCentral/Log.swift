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
    let category: Int
    let level: LogLevel
    
    var logPrefix: String = ""
    
    init(_ origin: Log.Origin, _ category: Int, _ level: LogLevel, _ message: String) {
        self.origin = origin
        self.category = category
        self.message = message
        self.level = level
        
        let name = String(origin.file.split(separator: "/").last) ?? origin.function
        logPrefix = "[\(name):\(origin.line)]"
    }
}

extension Log {
    struct Origin {
        let dso: UnsafeRawPointer?
        let file: String
        let line: Int
        let function: String
        
        init(_ dso: UnsafeRawPointer?, _ file: String, _ line: Int, _ function: String) {
            self.dso = dso
            self.file = file
            self.line = line
            self.function = function
        }
    }
}
