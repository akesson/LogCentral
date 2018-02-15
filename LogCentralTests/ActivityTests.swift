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

    func testActivityError() {
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
    
    func throwser() throws {
        throw TestError.test
    }
}

