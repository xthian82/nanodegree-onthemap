//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Cristhian Jesus Recalde Franco on 1/27/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginFacebookButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: Window functions
    override func viewDidLoad() {
        super.viewDidLoad()
        clearTextFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearTextFields()
    }
    
    //MARK: Button Actions
    @IBAction func loginTapped(_ sender: UIButton) {
        if self.emailTextField.text?.count == 0 || self.passwordTextField.text?.count == 0 {
            ControllersUtil.showAlert(controller: self, title: Errors.mainTitle, message: Errors.requiredLoginFields)
            return
        }
        setLoggingIn(true)
        UdacityClient.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "",
                    completion: self.handleLoginResponse(success:error:))
    }
    
    @IBAction func loginViaWebsiteTapped() {
        setLoggingIn(true)
        /*TMDBClient.getRequestToken { (success, error) in
            if success {
                UIApplication.shared.open(TMDBClient.Endpoints.webAuth.url, options: [:], completionHandler: nil)
            }
        }*/
    }
    
    @IBAction func signupTapped() {
        UIApplication.shared.open(URL(string: Constants.signUpLink)!, options: [:], completionHandler: nil)
    }
    
    //MARK: Delegate API functions
    func handleLoginResponse(success: Bool, error: Error?) {
           if success {
               UdacityClient.getUserData(completion: self.handleSessionResponse(userData:error:))
           } else {
            setLoggingIn(false)
            ControllersUtil.showAlert(controller: self, title: Errors.loginErrorTitle, message: error?.localizedDescription ?? "")
           }
    }
    
    func handleSessionResponse(userData: UserData?, error: Error?) {
        if let _ = userData {
            UdacityClient.getStudentLocations(completion: self.handleDataResponse(locations:error:))
        } else {
            setLoggingIn(false)
            ControllersUtil.showAlert(controller: self, title: Errors.dataErrorTitle, message: error?.localizedDescription ?? "")
        }
    }
    
    func handleDataResponse(locations: [StudentInformation], error: Error?) {
        if let error = error {
            setLoggingIn(false)
            ControllersUtil.showAlert(controller: self, title: Errors.locationErrorTitle, message: error.localizedDescription)
            return
        }
        setLoggingIn(false)
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.locations = locations
        clearTextFields()
        self.performSegue(withIdentifier: Constants.loggedInSegue, sender: nil)
    }
    
    //MARK: Helper methods
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        self.emailTextField.isEnabled = !loggingIn
        self.passwordTextField.isEnabled = !loggingIn
        self.loginButton.isEnabled = !loggingIn
        //self.loginFacebookButton.isEnabled = !loggingIn
    }
    
    func clearTextFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
}
