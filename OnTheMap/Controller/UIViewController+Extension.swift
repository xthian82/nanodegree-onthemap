//
//  UIViewController+Extension.swift
//  OnTheMap
//
//  Created by Cristhian Recalde on 1/26/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import UIKit

extension UIViewController {
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        UdacityClient.logout { (error) in
            if let error = error {
                let alert = ControllersUtil.getDefaultFailureUI(title: Errors.mainTitle, message: error.localizedDescription)
                self.present(alert, animated: true, completion: nil)
            }
            
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
