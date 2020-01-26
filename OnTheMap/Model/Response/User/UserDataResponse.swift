//
//  UserDataResponse.swift
//  OnTheMap
//
//  Created by Cristhian Recalde on 1/26/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import Foundation

struct UserDataResponse: Codable {
    
    let user: UserData
    
    enum CodingKeys: String, CodingKey {
        case user
    }
}
