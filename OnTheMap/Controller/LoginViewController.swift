//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Cristhian Jesus Recalde Franco on 1/27/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginFacebookButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        setLoggingIn(true)
        UdacityClient.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "",
                    completion: self.handleLoginResponse(success:error:))
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
           if success {
               UdacityClient.getUserData(completion: self.handleSessionResponse(userData:error:))
           } else {
               showLoginFailure(message: error?.localizedDescription ?? "")
           }
    }
    
    func handleSessionResponse(userData: UserDataResponse?, error: Error?) {
        if let userData = userData {
            UdacityClient.getStudentLocations(completion: self.handleDataResponse(locations:error:))
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func handleDataResponse(locations: [StudentInformation]?, error: Error?) {
        if let error = error {
            showLoginFailure(message: error.localizedDescription ?? "")
            return
        }
        setLoggingIn(false)
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.locations = locations
        self.performSegue(withIdentifier: "completeLogin", sender: nil)
    }
    
    @IBAction func loginViaWebsiteTapped() {
        setLoggingIn(true)
        /*TMDBClient.getRequestToken { (success, error) in
            if success {
                UIApplication.shared.open(TMDBClient.Endpoints.webAuth.url, options: [:], completionHandler: nil)
            }
        }*/
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        self.emailTextField.isEnabled = !loggingIn
        self.passwordTextField.isEnabled = !loggingIn
        self.loginButton.isEnabled = !loggingIn
        self.loginFacebookButton.isEnabled = !loggingIn
    }
    
    func showLoginFailure(message: String) {
        setLoggingIn(false)
        let alertVC = ControllersUtil.getDefaultFailureUI(title: "Login Failed", message: message)
        show(alertVC, sender: nil)
    }
}
