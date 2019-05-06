//
//  InfoLogTests.swift
//  LogCentralTests
//
//  Created by Henrik Akesson on 16/02/2018.
//  Copyright © 2018 Henrik Akesson. All rights reserved.
//

import XCTest
@testable import LogCentral

class InfoLogTests: XCTestCase {

    var infoLogger = TestLogger([.info])
    
    override func setUp() {
        infoLogger = TestLogger([.info])
        loggers = [infoLogger]
    }
    
    func testInfoStringLog() {
        log.info(in: .view, "My string")
        XCTAssertEqual(infoLogger.last, "[info - view] My string")
    }
    
    func testInfoDictLog() {
        log.info(in: .model, ["key" : 12])
        XCTAssertEqual(infoLogger.last, "[info - model] [\"key\": 12]")
    }
    
    func testInfoStructLog() {
        log.info(in: .model, DataStruct())
        XCTAssertEqual(infoLogger.last, "[info - model] LogCentralTests.DataStruct(value1: \"first value\", int1: 1, float1: 1.0)")
    }

    func testInfoAnyLog() {
        log.info(in: .model, "Hi Any" as Any)
        XCTAssertEqual(infoLogger.last, "[info - model] \"Hi Any\"")
    }
}
