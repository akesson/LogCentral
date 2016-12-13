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

    func testExampleLog() {
        log.debug(in: .Model, "")
        log.activity(for: .external, in: .Model, "") {
            
        }
    }
}
