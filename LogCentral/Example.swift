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

enum Categories: Int, CategorySpec {
    case View, ViewModel, Model, Service
    
    static let asArray:[Categories] = [.View, .ViewModel, .Model, .Service]
}

let crashLogger = LogWriter(levels: [.info]) {
    (message, level) in
    //write something somewhere
}

let log = LogCentral3Lvl<Categories, MyActivities>(subsystem: "mobi.akesson.logcentral", categories: Categories.asArray, loggers: [crashLogger])


func test() {
    log.debug(in: .Model, "")
}
