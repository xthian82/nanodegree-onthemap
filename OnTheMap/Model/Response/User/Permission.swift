//
//  Permission.swift
//  OnTheMap
//
//  Created by Cristhian Recalde on 1/26/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import Foundation

struct Permission: Codable {

    let derivation: [String]
    let behavior: String
    let principalRef: RefKey
    
    enum CodingKeys: String, CodingKey {

        case derivation
        case behavior
        case principalRef = "principal_ref"
    }
}

