//
//  PostLocationViewController.swift
//  OnTheMap
//
//  Created by Cristhian Jesus Recalde Franco on 1/28/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import UIKit

class PostLocationViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var locationTextfield: UITextField!
    @IBOutlet weak var mediaURLTextfield: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    
    var location: String?
    var mediaURL: String?
    var isUpdate = false
    
    //MARK: Window Actions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationTextfield.text = location ?? ""
        mediaURLTextfield.text = mediaURL ?? ""
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
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
        mapDetailViewController.location = self.locationTextfield.text!
        mapDetailViewController.mediaURL = self.mediaURLTextfield.text!
        mapDetailViewController.isUpdate = self.isUpdate
        self.navigationController!.pushViewController(mapDetailViewController, animated: true)
    }
    
    @IBAction func cancelActionTapped() {
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}
