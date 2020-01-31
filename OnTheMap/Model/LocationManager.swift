//
//  LocationManager.swift
//  OnTheMap
//
//  Created by Cristhian Recalde on 1/30/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import UIKit

class LocationManager {

    static let shared = LocationManager()

    // Serial dispatch queue
    private let lockQueue = DispatchQueue(label: "LocationManager.lockQueue")

    private var _locations: [StudentInformation]
    var locations: [StudentInformation] {
        get {
            return lockQueue.sync {
                return _locations
            }
        }

        set {
            lockQueue.sync {
                _locations = newValue
            }
        }
    }

    private var _loginType: LoginType
    var loginType: LoginType {
        get {
            return lockQueue.sync {
                return _loginType
            }
        }

        set {
            lockQueue.sync {
                _loginType = newValue
            }
        }
    }

    private init() {
        _locations = []
        _loginType = .UDACITY
    }
}
