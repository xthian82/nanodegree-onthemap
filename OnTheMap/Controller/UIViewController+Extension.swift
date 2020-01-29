//
//  UIViewController+Extension.swift
//  OnTheMap
//
//  Created by Cristhian Recalde on 1/26/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

extension UIViewController {
    
    func logginOut(_ sender: UIBarButtonItem, facebookLogin: Bool, activityIndicator: UIActivityIndicatorView) {
        activityIndicator.startAnimating()
        if facebookLogin {
            LoginManager().logOut()
            activityIndicator.stopAnimating()
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            UdacityClient.logout { (error) in
                activityIndicator.stopAnimating()
                if let error = error {
                    ControllersUtil.presentAlert(controller: self, title: Errors.mainTitle, message: error.localizedDescription)
                }
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func navigateToPostLocation(_ sender: UIBarButtonItem, activityIndicator: UIActivityIndicatorView) {
        let locationController = self.storyboard!.instantiateViewController(withIdentifier: Constants.postLocationSegue) as! PostLocationViewController
        
        activityIndicator.startAnimating()
        UdacityClient.getStudentLocationById() { (studentInformation, error) in
            activityIndicator.stopAnimating()
            if let studentInformation = studentInformation {
                ControllersUtil.presentConfirmationAlert(controller: self, title: Constants.confirmTitle, message: Constants.locationAlreadyAdded) { (okPressed, cancelPressed) in
                    if (cancelPressed) {
                        return
                    } else {
                        locationController.mediaURL = studentInformation.mediaURL
                        locationController.location = studentInformation.mapString
                        self.navigationController!.pushViewController(locationController, animated: true)
                    }
                }
            } else {
                self.navigationController!.pushViewController(locationController, animated: true)
            }
        }
    }
}
