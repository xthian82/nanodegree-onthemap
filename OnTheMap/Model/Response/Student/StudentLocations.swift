//
//  StudentLocations.swift
//  OnTheMap
//
//  Created by Cristhian Recalde on 1/27/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import Foundation

struct StudentLocations: Codable {

    let results: [StudentInformation]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}
