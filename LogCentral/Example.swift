//
//  Example.swift
//  LogCentral
//
//  Created by Henrik Akesson on 3/12/16.
//  Copyright © 2016 Henrik Akesson. All rights reserved.
//

import Foundation

enum Activities: Int, LoggerSpec {
    case user, extenal, `internal`
}

enum MyLoggers: Int, LoggerSpec {
    case View, ViewModel, Model, Service
    
    static let asArray:[MyLoggers] = [.View, .ViewModel, .Model, .Service]
}

let log = LogCentral<MyLoggers>(subsystem: "com.klap.piercus", loggers: MyLoggers.asArray)

