//
//  Example.swift
//  LogCentral
//
//  Created by Henrik Akesson on 3/12/16.
//  Copyright © 2016 Henrik Akesson. All rights reserved.
//

import Foundation
@testable import LogCentral

enum MyActivities: ActivitySpec {
    case user, external, `internal`
    
    var isTopLevel: Bool { return self != .internal }
}

enum Categories: Int, CategorySpec {
    case view, model
    
    static let asArray:[Categories] = [.view, .model]
}

let crashLogger = LogWriter(levels: [.info], messageWriter: { (msg, lvl) in
    //log messages here
}) { (err) in
    //log handled error objects here
}

let log = LogCentral3Lvl<Categories, MyActivities>(subsystem: "mobi.akesson.logcentral", loggers: [crashLogger])


