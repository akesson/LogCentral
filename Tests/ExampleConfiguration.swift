//
//  ExampleConfiguration.swift
//  LogCentral
//
//  Created by Henrik Akesson on 3/12/16.
//  Copyright © 2016 Henrik Akesson. All rights reserved.
//

import Foundation
@testable import LogCentral

enum Categories: Int, CategorySpec {
    case view, model
    
    public var name: String {
        return "\(self)"
    }

    static let asArray:[Categories] = [.view, .model]
}

let crashLogger = LogWriter(levels: [.info], { log in
    //log messages here
}) { (error, origin) in
    //log handled error objects here
}

let log = LogCentral5Lvl<Categories>(subsystem: "mobi.akesson.logcentral")


