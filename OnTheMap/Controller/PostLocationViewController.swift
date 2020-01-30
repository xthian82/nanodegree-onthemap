//
//  PostLocationViewController.swift
//  OnTheMap
//
//  Created by Cristhian Jesus Recalde Franco on 1/28/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import UIKit

class PostLocationViewController: UIViewController, UITextFieldDelegate {
    //MARK: Properties
    @IBOutlet weak var locationTextfield: UITextField!
    @IBOutlet weak var mediaURLTextfield: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    
    var dataDto: RequestDto?
    
    //MARK: Window Actions
    override func viewDidLoad() {
        super.viewDidLoad()

        locationTextfield.delegate = self
        mediaURLTextfield.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationTextfield.text = dataDto?.locationMap ?? ""
        mediaURLTextfield.text = dataDto?.mediaURL ?? ""
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Action Buttons
    @IBAction func findLocationTapped() {
        if self.locationTextfield.text?.count == 0 || self.mediaURLTextfield.text?.count == 0 {
            ControllersUtil.presentAlert(controller: self, title: Errors.mainTitle, message: Errors.requiredLocationFields)
            return
        }

        if !ValidatorsUtil.isValidUrl(urlLink: mediaURLTextfield.text) {
            ControllersUtil.presentAlert(controller: self, title: Errors.mainTitle, message: "Invalid url")
            return
        }

        let mapDetailViewController = self.storyboard!.instantiateViewController(withIdentifier: Constants.searchLocationSeugue) as! MapDetailViewController
        mapDetailViewController.dataDto = RequestDto(latitude: 0.0, longitude: 0.0, mediaURL: self.mediaURLTextfield.text!, locationMap: self.locationTextfield.text!, objectId: self.dataDto?.objectId)
        self.navigationController!.pushViewController(mapDetailViewController, animated: true)
    }
    
    @IBAction func cancelActionTapped() {
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}
