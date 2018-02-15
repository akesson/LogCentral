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

class TestLogger: LoggerSpec {
    var messageWriter: LogMessageWriter = { _, _ in }
    var errorObjectWriter: LogErrorObjectWriter?
    let levels: [LogLevel]
    
    var lastLog: (level: LogLevel, message: String)?
    var lastError: Error?
    
    var last: String {
        if let error = lastError {
            return error.localizedDescription
        } else if let log = lastLog {
            return "[\(log.level)] \(log.message)"
        } else {
            return "Nothing logged"
        }
    }
    
    init(_ levels: [LogLevel]) {
        self.levels = levels
        errorObjectWriter = { error in
            self.lastLog = nil
            self.lastError = error
        }
        messageWriter = { message, level in
            self.lastLog = (level, message)
            self.lastError = nil
        }
    }
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
    
    func testActivity() {
        let myActivity = Activity("MY_ACTIVITY", parent: .none)
        myActivity.active {
            log.error(in: .model, "Howdy \(3+2)")
        }

        
        let mySecondActivity = Activity("SECOND_ACTIVITY")
        var scope2 = mySecondActivity.enter()
        
        log.error(in: .model, "MY_ERROR")
        scope2.leave()
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
    
    func testError() {
        log.error(in: .model, "TEST WRAPPED")
        
        var caught = false
        do {
            try log.rootActivity("MY_ACTIVITY_WRAPPED") {
                log.info(in: .view, "SOME ERROR WRAPPED")
                
                log.info(in: .view, "SOME ERROR WRAPPED")
                
                try throwser()
                
            }
        } catch TestError.test {
            caught = true
        } catch {
            
        }
        
        XCTAssert(caught)
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
    
    func throwser() throws {
        throw TestError.test
    }
}
