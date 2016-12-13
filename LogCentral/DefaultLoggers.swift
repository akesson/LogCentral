//
//  DefaultLoggers.swift
//  LogCentral
//
//  Created by Henrik Akesson on 13/12/16.
//  Copyright © 2016 Henrik Akesson. All rights reserved.
//

import Foundation


enum MVVMSLoggers: Int, LoggerSpec {
    case View, ViewModel, Model, Service
    
    static let asArray:[MVVMSLoggers] = [.View, .ViewModel, .Model, .Service]
}


enum MVCSLoggers: Int, LoggerSpec {
    case View, Model, Controller, Service
    
    static let asArray:[MVCSLoggers] = [.View, .Model, .Controller, .Service]
    
}
