//
//  HttpKeys.swift
//  OnTheMap
//
//  Created by Cristhian Recalde on 1/26/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import Foundation

enum HttpKeys: String {
    
    case acceptHeader = "Accept"
    case contentTypeHeader = "Content-Type"
    case json = "application/json"
    
    var value: String {
        return self.rawValue
    }
}
