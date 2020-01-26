//
//  Email.swift
//  OnTheMap
//
//  Created by Cristhian Recalde on 1/26/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import Foundation

struct Email: Codable {

    let verificationCodeSent: Bool
    let verified: Bool
    let address: String
    
    enum CodingKeys: String, CodingKey {

        case verificationCodeSent = "_verification_code_sent"
        case verified = "_verified"
        case address
    }
}
