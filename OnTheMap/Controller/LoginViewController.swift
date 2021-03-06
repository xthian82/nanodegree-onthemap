//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Cristhian Jesus Recalde Franco on 1/27/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginFacebookButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    //MARK: Window functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        clearTextFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearTextFields()
    }
    
    //MARK: Button Actions
    @IBAction func loginTapped(_ sender: UIButton) {
        // simple validation of required values
        if emailTextField.text?.count == 0 || passwordTextField.text?.count == 0 {
            ControllersUtil.showAlert(controller: self, title: Errors.mainTitle, message: Errors.requiredLoginFields)
            return
        }
        setLoggingIn(true)
        UdacityClient.login(username: emailTextField.text ?? "", password: passwordTextField.text ?? "",
                    completion: handleUdacityLoginResponse(success:error:))
    }
    
    @IBAction func facebookLoginTapped() {
        setLoggingIn(true)
        let manager = LoginManager()
        manager.logIn(permissions: [.publicProfile, .email], viewController: self, completion: self.handleFaceebookLoginResponse(result:))
    }
    
    @IBAction func signupTapped() {
        UIApplication.shared.open(URL(string: Constants.signUpLink)!, options: [:], completionHandler: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Delegate API functions
    func handleUdacityLoginResponse(success: Bool, error: Error?) {
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
        LocationManager.shared.locations = locations
        clearTextFields()
        self.performSegue(withIdentifier: Constants.loggedInSegue, sender: nil)
    }
    
    func handleFaceebookLoginResponse(result: LoginResult) {
        setLoggingIn(false)
        LocationManager.shared.loginType = .FACEBOOK
        //handle reponse
        switch result {
        case .cancelled:
            ControllersUtil.showAlert(controller: self, title: Errors.mainTitle, message: Errors.requestCancelledByUser)
        case .failed(let error):
            ControllersUtil.showAlert(controller: self, title: Errors.mainTitle, message: error.localizedDescription)
        case .success(_, _, let accessToken):
            UdacityClient.setAuthData(accountId: accessToken.userID, sessionId: accessToken.tokenString,
                                      firstName: Profile.current?.firstName, lastName: Profile.current?.lastName)
            UdacityClient.getStudentLocations(completion: self.handleDataResponse(locations:error:))
        }
    }
    
    //MARK: Helper methods
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
        loginFacebookButton.isEnabled = !loggingIn
    }
    
    func clearTextFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
}
