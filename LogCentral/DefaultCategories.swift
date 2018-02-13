//
//  DefaultCategories.swift
//  LogCentral
//
//  Created by Henrik Akesson on 13/12/16.
//  Copyright © 2016 Henrik Akesson. All rights reserved.
//

import Foundation


public enum MVVMS: Int, CategorySpec {
    case view, viewModel, model, service
    
    public static let asArray:[MVVMS] = [.view, .viewModel, .model, .service]
}

public enum MVVM: Int, CategorySpec {
    case view, viewModel, model
    
    public static let asArray:[MVVM] = [.view, .viewModel, .model]
}


public enum MVCS: Int, CategorySpec {
    case view, model, controller, service
    
    public static let asArray:[MVCS] = [.view, .model, .controller, .service]
    
}

public enum MVC: Int, CategorySpec {
    case view, model, controller
    
    public static let asArray:[MVC] = [.view, .model, .controller]
    
}
