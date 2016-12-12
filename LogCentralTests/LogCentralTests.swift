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
    
    let myLogger = OSLog(subsystem: "HENRIK", category: "LOG TEST")
    
    func testXLog() {
        let loguser = LogUser()
        os_log("Swift", log: myLogger, type: .info)
        loguser.sendALog(myLogger)
        //verify that both "Swift" and "ObjC" are in the console log
    }
    
    func testXActivity() {
        let loguser = LogUser()
        
        loguser.activity(with: myLogger)
    }
    
    func testWorksOnPhone() {
        //tested on iOS 10.1
        let loguser = LogUser()
        loguser.worksOnPhone()
    }
    
    func testEnum() {
        log_info(MyLoggers.Model, "Hi from model")
        print("HHHHHH \(MyLoggers.Model)")
    }
}
