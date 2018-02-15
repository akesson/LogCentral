//
//  LogCentralTests.swift
//  LogCentralTests
//
//  Created by Henrik Akesson on 3/12/16.
//  Copyright © 2016 Henrik Akesson. All rights reserved.
//

import XCTest
@testable import LogCentral

enum TestError: Error {
    case test
}

class LogCentralTests: XCTestCase {

    var errorLogger = TestLogger([.error])
    var infoLogger = TestLogger([.info])
    var debugLogger = TestLogger([.debug])
    
    override func setUp() {
        loggers = []
        errorLogger = TestLogger([.error])
        infoLogger = TestLogger([.info])
        debugLogger = TestLogger([.debug])
    }
    
    func testExampleLog() {
        log.error(in: .model, "TEST WRAPPED")

        log.rootActivity("MY_ACTIVITY_WRAPPED") {
            log.info(in: .view, "SOME ERROR WRAPPED")
            
            log.activity("MY_ACTIVITY_WRAPPED_2", {
                log.debug(in: .view, "SOME ERROR WRAPPED 2")
            })
        }
    }
    
    func testOneCustomLogger() {
        let testLogger = TestLogger([.info])

        log.info(in: .view, "not yet configured")
        XCTAssertEqual(testLogger.last, "Nothing logged")
        
        LogCentral.loggers = [testLogger]
        
        log.info(in: .view, "first log")
        XCTAssertEqual(testLogger.last, "[info] first log")
        
        log.debug(in: .view, "should not appear in testlogger")
        XCTAssertEqual(testLogger.last, "[info] first log")
    }

    func testTwoCustomLoggers() {
        log.info(in: .view, "not yet configured")
        XCTAssertEqual(infoLogger.last, "Nothing logged")
        XCTAssertEqual(debugLogger.last, "Nothing logged")
        
        LogCentral.loggers = [infoLogger, debugLogger]
        
        log.info(in: .view, "first log")
        XCTAssertEqual(infoLogger.last, "[info] first log")
        XCTAssertEqual(debugLogger.last, "Nothing logged")

        log.debug(in: .view, "second log")
        XCTAssertEqual(infoLogger.last, "[info] first log")
        XCTAssertEqual(debugLogger.last, "[debug] second log")
    }

    func testOneDualLevelLogger() {
        let infoAndDebugLogger = TestLogger([.info, .debug])
        
        log.info(in: .view, "not yet configured")
        XCTAssertEqual(infoAndDebugLogger.last, "Nothing logged")
        
        LogCentral.loggers = [infoAndDebugLogger]
        
        log.info(in: .view, "first log")
        XCTAssertEqual(infoAndDebugLogger.last, "[info] first log")
        
        log.debug(in: .view, "second log")
        XCTAssertEqual(infoAndDebugLogger.last, "[debug] second log")
    }
    
    func testErrorLog() {
        loggers = [errorLogger]
        log.error(in: .view, TestError.test)
        XCTAssertEqual(errorLogger.last, "The operation couldn’t be completed. (LogCentralTests.TestError error 0.)")
    }
    
    func testNSErrorLog() {
        loggers = [errorLogger]
        log.error(in: .view, NSError(domain: "", code: 0, userInfo: nil))
        XCTAssertEqual(errorLogger.last, "The operation couldn’t be completed. ( error 0.)")
    }
}
