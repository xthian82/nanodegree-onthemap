//
//  PostLocationViewController.swift
//  OnTheMap
//
//  Created by Cristhian Jesus Recalde Franco on 1/28/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import UIKit
import MapKit

class PostLocationViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    //MARK: Properties
    @IBOutlet weak var locationTextfield: UITextField!
    @IBOutlet weak var mediaURLTextfield: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var activityIndicatoir: UIActivityIndicatorView!
    
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
        tabBarController?.tabBar.isHidden = true
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
        
        searchPlace(completion: handleSearchResponse(mapItem:error:))
    }
    
    @IBAction func cancelActionTapped() {
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    //MARK: Helpers
    func searchPlace(completion: @escaping (MKMapItem?, Error?) -> Void) {
        startAnimation(true)
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = locationTextfield.text

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            self.startAnimation(false)
            guard let response = response else {
                completion(nil, error)
                return
            }
            completion(response.mapItems[0], nil)
        }
    }
    
    func handleSearchResponse(mapItem: MKMapItem?, error : Error?) {
        if let _ = error {
            ControllersUtil.presentAlert(controller: self, title: Errors.locationErrorTitle, message: Errors.findLocationProblem)
            return
        }
        
        guard let mapItem = mapItem else {
            ControllersUtil.presentAlert(controller: self, title: Errors.locationErrorTitle, message: Errors.findLocationProblem)
            return
        }

        let mapDetailViewController = self.storyboard!.instantiateViewController(withIdentifier: Constants.searchLocationSeugue) as! MapDetailViewController
        mapDetailViewController.dataDto = RequestDto(latitude: mapItem.placemark.coordinate.latitude, longitude: mapItem.placemark.coordinate.longitude, mediaURL: mediaURLTextfield.text!, locationMap: locationTextfield.text!, objectId: dataDto?.objectId)
        mapDetailViewController.currentLocation = getAnnotationFromMapItem(mapItem)
        self.navigationController!.pushViewController(mapDetailViewController, animated: true)
    }
    
    func getAnnotationFromMapItem(_ mapItem: MKMapItem) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapItem.placemark.coordinate
        annotation.title = mapItem.name
        return annotation
    }
    
    func startAnimation(_ animate: Bool) {
        if animate {
            activityIndicatoir.startAnimating()
        } else {
            activityIndicatoir.stopAnimating()
        }
        findLocationButton.isEnabled = !animate
    }
}
