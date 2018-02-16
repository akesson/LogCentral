//
//  FaultLogTests.swift
//  LogCentralTests
//
//  Created by Henrik Akesson on 16/02/2018.
//  Copyright © 2018 Henrik Akesson. All rights reserved.
//

import XCTest
@testable import LogCentral

class FaultLogTests: XCTestCase {
    
    var faultLogger = TestLogger([.fault])
    
    override func setUp() {
        faultLogger = TestLogger([.fault])
        loggers = [faultLogger]
    }
    
    func testInfoStringLog() {
        log.fault(in: .view, "My string")
        XCTAssertEqual(faultLogger.last, "[fault - view] My string")
    }
    
    func testInfoDictLog() {
        log.fault(in: .model, ["key" : 12])
        XCTAssertEqual(faultLogger.last, "[fault - model] [\"key\": 12]")
    }
    
    func testInfoStructLog() {
        log.fault(in: .model, DataStruct())
        XCTAssertEqual(faultLogger.last, "[fault - model] LogCentralTests.DataStruct(value1: \"first value\", int1: 1, float1: 1.0)")
    }
    
    func testInfoAnyLog() {
        log.fault(in: .model, "Hi Any" as Any)
        XCTAssertEqual(faultLogger.last, "[fault - model] \"Hi Any\"")
    }
}

