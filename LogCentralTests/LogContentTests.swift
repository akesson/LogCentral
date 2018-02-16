//
//  LogContentTests.swift
//  LogCentralTests
//
//  Created by Henrik Akesson on 16/02/2018.
//  Copyright © 2018 Henrik Akesson. All rights reserved.
//

import XCTest
@testable import LogCentral

class LogContentTests: XCTestCase {
    
    var infoLogger = TestLogger([.info])
    
    override func setUp() {
        infoLogger = TestLogger([.info])
        loggers = [infoLogger]
    }
    
    func testContent() {
        log.info(in: .view, "My log"); let lineNumber = #line

        guard let logData = infoLogger.lastLog else {
            XCTFail()
            return
        }

        XCTAssertEqual(logData.subsystem, "mobi.akesson.logcentral")
        XCTAssertEqual(logData.category.name, "view")
        XCTAssertEqual(logData.consoleFormattedMessage, "LogContentTests:22 My log")
        XCTAssertEqual(logData.description, "[info] LogContentTests:22 My log")
        XCTAssertEqual(logData.formattedMessage, "[info] LogContentTests:22 My log")
        XCTAssertEqual(logData.level, .info)
        XCTAssertEqual(logData.message, "My log")
        XCTAssertEqual(logData.origin.filename, "LogContentTests")
        XCTAssertEqual(logData.origin.function, "testContent()")
        XCTAssertEqual(logData.origin.line, lineNumber)
        XCTAssertEqual(logData.origin.logPrefix, "LogContentTests:22")
    }
}

