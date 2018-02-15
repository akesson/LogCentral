//
//  ErrorLogTests.swift
//  LogCentralTests
//
//  Created by Henrik Akesson on 15/02/2018.
//  Copyright © 2018 Henrik Akesson. All rights reserved.
//

import XCTest
@testable import LogCentral

class ErrorLogTests: XCTestCase {
    var errorLogger = TestLogger([.error])

    override func setUp() {
        errorLogger = TestLogger([.error])
        loggers = [errorLogger]
    }
    
    func testErrorStructLog() {
        log.error(in: .view, DataStruct())
        XCTAssertEqual(errorLogger.last, "LogCentralTests.DataStruct(value1: \"first value\", int1: 1, float1: 1.0)")
    }
    
    func testErrorDicitionaryLog() {
        let dict = ["key1" : 1, "key2" : 2]
        log.error(in: .view, dict)
        XCTAssertEqual(errorLogger.last, "[\"key2\": 2, \"key1\": 1]")
    }
    
    func testErrorMessageLog() {
        log.error(in: .view, "My error message")
        XCTAssertEqual(errorLogger.last, "My error message")
    }
    
    func testErrorLog() {
        log.error(in: .view, TestError.test)
        XCTAssertEqual(errorLogger.last, "The operation couldn’t be completed. (LogCentralTests.TestError error 0.)")
    }
    
    func testNSErrorLog() {
        log.error(in: .view, NSError(domain: "", code: 0, userInfo: nil))
        XCTAssertEqual(errorLogger.last, "The operation couldn’t be completed. ( error 0.)")
    }
    
    func testNilLog() {
        log.error(in: .view, nil)
        XCTAssertEqual(errorLogger.last, "[error - view] The operation couldn’t be completed. (error object was nil)")
    }
}
