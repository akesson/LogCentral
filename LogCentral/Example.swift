//
//  Example.swift
//  LogCentral
//
//  Created by Henrik Akesson on 3/12/16.
//  Copyright © 2016 Henrik Akesson. All rights reserved.
//

import Foundation

enum MyActivities: ActivitySpec {
    case user, external, `internal`
    
    var isTopLevel: Bool { return self != .internal }
}

enum MyLoggers: Int, LoggerSpec {
    case View, ViewModel, Model, Service
    
    static let asArray:[MyLoggers] = [.View, .ViewModel, .Model, .Service]
}

let log = LogCentral3Lvl<MyLoggers, MyActivities>(subsystem: "mobi.akesson.logcentral", loggers: MyLoggers.asArray)


func test() {
    log.debug(in: .Model, "")
}
