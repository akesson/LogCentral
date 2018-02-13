//
//  LogCentralTests.swift
//  LogCentralTests
//
//  Created by Henrik Akesson on 3/12/16.
//  Copyright © 2016 Henrik Akesson. All rights reserved.
//

import XCTest
@testable import LogCentral


class LogCentralTests: XCTestCase {

    func testActivity() {
        let myActivity = Activity("MY_ACTIVITY", parent: .none)
        var scope = myActivity.enter()
        defer { scope.leave() }

        log.error(in: .Model, "Howdy \(3+2)")

        
        let mySecondActivity = Activity("SECOND_ACTIVITY")
        var scope2 = mySecondActivity.enter()
        
        log.error(in: .Model, "MY_ERROR")
        scope2.leave()
    }

    func testExampleLog() {
        log.error(in: .Model, "TEST WRAPPED")

        log.activity(for: .external, "MY_ACTIVITY_WRAPPED") {
            log.info(in: .View, "SOME ERROR WRAPPED")
            
            log.activity(for: .internal, "MY_ACTIVITY_WRAPPED_2", {
                log.debug(in: .View, "SOME ERROR WRAPPED 2")
            })
        }
    }
}
