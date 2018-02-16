//
//  ActivityTests.swift
//  LogCentralTests
//
//  Created by Henrik Akesson on 15/02/2018.
//  Copyright © 2018 Henrik Akesson. All rights reserved.
//

import XCTest
@testable import LogCentral

class ActivityTests: XCTestCase {
    
    /// THESE TESTS NEEDS TO BE MANUALLY VERIFIED IN THE CONSOLE
    
    var infoLogger = TestLogger([.info])
    
    override func setUp() {
        infoLogger = TestLogger([.info])
        loggers = [infoLogger]
    }

    func testInternalActivity() {
        let myActivity = Activity("first internal root activity", parent: .none)
        myActivity.active {
            log.info(in: .model, "inside first internal root activity")
            
            
            let mySecondActivity = Activity("nested internal activity")
            var scope2 = mySecondActivity.enter()
            
            log.info(in: .model, "inside nested internal activity")
            scope2.leave()
        }
    }

    func testRootAndNestedActivity() {
        log.info(in: .model, "before root activity")
        
        log.rootActivity("root activity") {
            log.info(in: .view, "inside root activity")
            
            log.activity("nested activity", {
                log.info(in: .model, "inside nested activity")
            })
        }
    }
    
    func testActivityWithReturn() {
        XCTAssertTrue(activityWithReturn())
    }

    func activityWithReturn() -> Bool {
        return log.activity("root activity") {
            return true
        }
    }

    func testDualRootActivity() {
        log.info(in: .model, "before root activity")
        
        log.rootActivity("root activity") {
            log.info(in: .view, "inside root activity")
            
            log.rootActivity("second root activity", {
                log.info(in: .model, "inside second root activity")
            })
        }
    }

    func testRootActivityError() {
        log.info(in: .model, "before root activity")
        
        var caught = false
        do {
            try log.rootActivity("root activity") {
                log.info(in: .view, "before root activity error")
                
                try throwser()
                
                log.info(in: .view, "after root activity error")
            }
        } catch TestError.test {
            caught = true
        } catch {
            XCTFail()
        }
        XCTAssert(caught)
    }

    
    func throwser() throws {
        throw TestError.test
    }
}

