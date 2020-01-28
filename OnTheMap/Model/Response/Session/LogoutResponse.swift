//
//  LogoutResponse.swift
//  OnTheMap
//
//  Created by Cristhian Recalde on 1/28/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import Foundation

struct LogoutResponse: Codable {
    let session: Session
    
    enum CodingKeys: String, CodingKey {
        case session
    }
}
