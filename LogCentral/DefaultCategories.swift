//
//  DefaultCategories.swift
//  LogCentral
//
//  Created by Henrik Akesson on 13/12/16.
//  Copyright © 2016 Henrik Akesson. All rights reserved.
//

import Foundation


public enum MVVMS: Int, CategorySpec {
    case View, ViewModel, Model, Service
    
    public static let asArray:[MVVMS] = [.View, .ViewModel, .Model, .Service]
}


public enum MVCS: Int, CategorySpec {
    case View, Model, Controller, Service
    
    public static let asArray:[MVCS] = [.View, .Model, .Controller, .Service]
    
}
