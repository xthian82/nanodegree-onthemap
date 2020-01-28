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
    
    class func getDefaultAlertUI(title: String, message: String) -> UIAlertController {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alertVC
    }
    
    class func getDefaultConfirmationUI(title: String, message: String, completion: @escaping (Bool, Bool) -> ()) -> UIAlertController {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
                     
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            completion(true, false)
        })
                     
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            completion(false, true)
        }
                     
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        return dialogMessage
    }
    
    class func presentConfirmationAlert(controller: UIViewController, title: String, message: String, completion: @escaping (Bool, Bool) -> ()) {
        let confirmationAlert = getDefaultConfirmationUI(title: title, message: message, completion: completion)
        controller.present(confirmationAlert, animated: true, completion: nil)
    }
    
    class func presentAlert(controller: UIViewController, title: String, message: String) {
        let alert = getDefaultAlertUI(title: title, message: message)
        controller.present(alert, animated: true, completion: nil)
    }
    
    class func showAlert(controller: UIViewController, title: String, message: String) {
        let alert = getDefaultAlertUI(title: title, message: message)
        controller.show(alert, sender: nil)
    }
}
