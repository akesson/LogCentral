//
//  LazyString.swift
//  LogCentral
//
//  Created by Henrik Akesson on 13/12/16.
//  Copyright © 2016 Henrik Akesson. All rights reserved.
//

import Foundation

final class LazyString: CustomStringConvertible {
    let message:StaticString
    let args:CVarArg?
    
    private var _string: String?
    var description: String {
        if let _string = _string {
            return _string
        }
        if let args = args {
            _string = String(format: message.description, args)
        } else {
            _string = String(describing: message)
        }
        return _string!
    }
    
    init(_ message: StaticString, _ args: CVarArg...) {
        self.message = message
        self.args = args
    }
    
    init(_ message: String) {
        self._string = message
        self.message = ""
        self.args = nil
    }
    
    
}
