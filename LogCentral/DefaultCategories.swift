//
//  DefaultCategories.swift
//  LogCentral
//
//  Created by Henrik Akesson on 13/12/16.
//  Copyright © 2016 Henrik Akesson. All rights reserved.
//

import Foundation


enum MVVMS: Int, CategorySpec {
    case View, ViewModel, Model, Service
    
    static let asArray:[MVVMS] = [.View, .ViewModel, .Model, .Service]
}


enum MVCS: Int, CategorySpec {
    case View, Model, Controller, Service
    
    static let asArray:[MVCS] = [.View, .Model, .Controller, .Service]
    
}
