//
//  EmailPreference.swift
//  OnTheMap
//
//  Created by Cristhian Recalde on 1/26/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import Foundation

struct EmailPreference: Codable {

    let okUser: Bool
    let master: Bool
    let okCourse: Bool
    
    enum CodingKeys: String, CodingKey {
        case okUser = "ok_user_research"
        case master = "master_ok"
        case okCourse = "ok_course"
    }
}
