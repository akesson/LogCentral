//
//  Level.swift
//  LogCentral
//
//  Created by Henrik Akesson on 13/12/16.
//  Copyright © 2016 Henrik Akesson. All rights reserved.
//

import Foundation
import os.log

public enum LogLevel: Int {
    case info, debug, `default`, error, fault
    
    @available(iOS 10.0, *)
    var osLogType: OSLogType {
        switch self {
        case .debug:
            return OSLogType.debug
        case .default:
            return OSLogType.default
        case .error:
            return OSLogType.error
        case .fault:
            return OSLogType.fault
        case .info:
            return OSLogType.info
        }
    }
}
