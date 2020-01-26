//
//  Guard.swift
//  OnTheMap
//
//  Created by Cristhian Recalde on 1/26/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import Foundation

struct Guard: Codable {

    let canEdit: Bool
    let permissions: [Permission]
    let allowedBehaviors: [String]
    let subjectKind: String
    
    enum CodingKeys: String, CodingKey {
        case canEdit = "can_edit"
        case permissions
        case allowedBehaviors = "allowed_behaviors"
        case subjectKind = "subject_kind"
    }
}
