//
//  SessionRequest.swift
//  OnTheMap
//
//  Created by Cristhian Recalde on 1/26/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import Foundation

struct SessionRequest: Codable {
    
    let udacity: LoginData
    
    enum CodingKeys: String, CodingKey {
        case udacity
    }
}
