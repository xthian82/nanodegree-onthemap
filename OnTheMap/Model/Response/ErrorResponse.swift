//
//  ErrorResponse.swift
//  OnTheMap
//
//  Created by Cristhian Recalde on 1/27/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import Foundation

struct ErrorResponse: Codable {
    let status: Int
    let error: String
    
    enum CodingKeys: String, CodingKey {
        case status
        case error
    }
}


extension ErrorResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
