//
//  ValidatorsUtil.swift
//  OnTheMap
//
//  Created by Cristhian Recalde on 1/29/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import UIKit

class ValidatorsUtil {
    
    class func isValidUrl(urlLink: String?) -> Bool {
        if let url = URL(string: urlLink ?? ""), UIApplication.shared.canOpenURL(url) {
            return true
        }
        return false
    }
}
