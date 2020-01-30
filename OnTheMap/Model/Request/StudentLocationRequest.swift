//
//  StudentLocationRequest.swift
//  OnTheMap
//
//  Created by Cristhian Recalde on 1/26/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import Foundation

struct StudentLocationRequest: Codable {

    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let uniqueKey: String
    
    enum CodingKeys: String, CodingKey {
        case firstName
        case lastName
        case latitude
        case longitude
        case mapString
        case mediaURL
        case uniqueKey
    }
}
