//
//  DefaultLogTests.swift
//  LogCentralTests
//
//  Created by Henrik Akesson on 16/02/2018.
//  Copyright © 2018 Henrik Akesson. All rights reserved.
//

import XCTest
@testable import LogCentral

class DefaultLogTests: XCTestCase {
    
    var defaultLogger = TestLogger([.default])
    
    override func setUp() {
        defaultLogger = TestLogger([.default])
        loggers = [defaultLogger]
    }
    
    func testInfoStringLog() {
        log.default(in: .view, "My string")
        XCTAssertEqual(defaultLogger.last, "[default - view] My string")
    }
    
    func testInfoDictLog() {
        log.default(in: .model, ["key" : 12])
        XCTAssertEqual(defaultLogger.last, "[default - model] [\"key\": 12]")
    }
    
    func testInfoStructLog() {
        log.default(in: .model, DataStruct())
        XCTAssertEqual(defaultLogger.last, "[default - model] LogCentralTests.DataStruct(value1: \"first value\", int1: 1, float1: 1.0)")
    }
    
    func testInfoAnyLog() {
        log.default(in: .model, "Hi Any" as Any)
        XCTAssertEqual(defaultLogger.last, "[default - model] \"Hi Any\"")
    }
}

