//
//  ControllersUtil.swift
//  OnTheMap
//
//  Created by Cristhian Recalde on 1/26/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import Foundation
import UIKit

class ControllersUtil {
    
    class func getDefaultFailureUI(title: String, message: String) -> UIAlertController {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alertVC
    }
    
    class func presentAlert(controller: UIViewController, title: String, message: String) {
        let alert = getDefaultFailureUI(title: title, message: message)
        controller.present(alert, animated: true, completion: nil)
    }
    
    class func showAlert(controller: UIViewController, title: String, message: String) {
        let alert = getDefaultFailureUI(title: title, message: message)
        controller.show(alert, sender: nil)
    }
}
