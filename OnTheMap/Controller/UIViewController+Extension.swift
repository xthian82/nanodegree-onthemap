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
    
    private func handleLogout(type: LoginType, finish: @escaping (Error?) -> Void) {
        switch type {
        case .FACEBOOK:
            LoginManager().logOut()
            finish(nil)
        case .UDACITY:
            UdacityClient.logout(completion: finish)
        }
    }
    
    func logginOut(_ sender: UIBarButtonItem, activityIndicator: UIActivityIndicatorView) {
        let loginType = (UIApplication.shared.delegate as! AppDelegate).loginType
        activityIndicator.startAnimating()
        
        handleLogout(type: loginType) { (error) in
            activityIndicator.stopAnimating()
            if let error = error {
                ControllersUtil.presentAlert(controller: self, title: Errors.mainTitle, message: error.localizedDescription)
            }
            
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
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
                        locationController.dataDto = RequestDto(latitude: 0.0, longitude: 0.0, mediaURL: studentInformation.mediaURL, locationMap: studentInformation.mapString, objectId: studentInformation.objectId)
                        self.navigationController!.pushViewController(locationController, animated: true)
                    }
                }
            } else {
                self.navigationController!.pushViewController(locationController, animated: true)
            }
        }
    }
}
