//
//  RefKey.swift
//  OnTheMap
//
//  Created by Cristhian Recalde on 1/26/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import Foundation

struct RefKey: Codable {

    let ref: String
    let key: String
    
    enum CodingKeys: String, CodingKey {

        case ref
        case key
    }
}
