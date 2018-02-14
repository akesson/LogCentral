//
//  ExampleCategories.swift
//  LogCentral
//
//  Created by Henrik Akesson on 13/12/16.
//  Copyright © 2016 Henrik Akesson. All rights reserved.
//

import Foundation
@testable import LogCentral

public enum MVVMS: Int, CategorySpec {
    /// For logging made in the view (in MVVMS)
    case view
    /// For logging made in the viewModel (in MVVMS)
    case viewModel
    /// For logging made in the model (in MVVMS)
    case model
    /// For logging made in the service (in MVVMS)
    case service
    
    public static let asArray:[MVVMS] = [.view, .viewModel, .model, .service]
}

public enum MVVM: Int, CategorySpec {
    /// For logging made in the view (in MVVM)
    case view
    /// For logging made in the viewModel (in MVVM)
    case viewModel
    /// For logging made in the model (in MVVM)
    case model
    
    public static let asArray:[MVVM] = [.view, .viewModel, .model]
}


public enum MVCS: Int, CategorySpec {
    /// For logging made in the view (in MVCS)
    case view
    /// For logging made in the model (in MVCS)
    case model
    /// For logging made in the controller (in MVCS)
    case controller
    /// For logging made in the service (in MVCS)
    case service
    
    public static let asArray:[MVCS] = [.view, .model, .controller, .service]
    
}

public enum MVC: Int, CategorySpec {
    /// For logging made in the view (in MVC)
    case view
    /// For logging made in the model (in MVC)
    case model
    /// For logging made in the controller (in MVC)
    case controller
    
    public static let asArray:[MVC] = [.view, .model, .controller]
}
