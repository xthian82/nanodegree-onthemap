//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Cristhian Recalde on 1/27/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import Foundation

struct StudentInformation: Codable, Equatable {
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt
        case firstName
        case lastName
        case latitude
        case longitude
        case mapString
        case mediaURL
        case objectId
        case uniqueKey
        case updatedAt
    }
}
