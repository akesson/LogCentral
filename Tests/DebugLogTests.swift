//
//  DebugLogTests.swift
//  LogCentralTests
//
//  Created by Henrik Akesson on 16/02/2018.
//  Copyright © 2018 Henrik Akesson. All rights reserved.
//

import XCTest
@testable import LogCentral

class DebugLogTests: XCTestCase {
    
    var debugLogger = TestLogger([.debug])
    
    override func setUp() {
        debugLogger = TestLogger([.debug])
        loggers = [debugLogger]
    }
    
    func testInfoStringLog() {
        log.debug(in: .view, "My string")
        XCTAssertEqual(debugLogger.last, "[debug - view] My string")
    }
    
    func testInfoDictLog() {
        log.debug(in: .model, ["key" : 12])
        XCTAssertEqual(debugLogger.last, "[debug - model] [\"key\": 12]")
    }
    
    func testInfoStructLog() {
        log.debug(in: .model, DataStruct())
        XCTAssertEqual(debugLogger.last, "[debug - model] LogCentralTests.DataStruct(value1: \"first value\", int1: 1, float1: 1.0)")
    }
    
    func testInfoAnyLog() {
        log.debug(in: .model, "Hi Any" as Any)
        XCTAssertEqual(debugLogger.last, "[debug - model] \"Hi Any\"")
    }
}
