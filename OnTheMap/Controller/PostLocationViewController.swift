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
    
    //MARK: Window Actions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Action Buttons
    @IBAction func findLocationTapped() {
        if self.locationTextfield.text?.count == 0 || self.mediaURLTextfield.text?.count == 0 {
            ControllersUtil.showAlert(controller: self, title: Errors.missingValuesTitle, message: Errors.requiredLocationFields)
            return
        }
    }
    
    @IBAction func cancelActionTapped() {
        dismiss(animated: true, completion: nil)
    }
}
