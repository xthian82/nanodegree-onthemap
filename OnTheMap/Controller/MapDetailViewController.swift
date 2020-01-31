//
//  MapDetailViewController.swift
//  OnTheMap
//
//  Created by Cristhian Jesus Recalde Franco on 1/29/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import UIKit
import MapKit

class MapDetailViewController : UIViewController, MKMapViewDelegate, UINavigationControllerDelegate {
 
    //MARK: Properties
    @IBOutlet weak var mapView: MKMapView!
    var currentLocation: MKPointAnnotation?
    var dataDto: RequestDto?
    @IBOutlet weak var finishButton: RoundButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: Navigation Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        navigateToLocation(annotation: currentLocation!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: Map Functions
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return ControllersUtil.getPinViewFromMap(mapView, annotation: annotation, identifier: Constants.pinId)
    }
    
    //MARK: Action Buttons
    @IBAction func cancelActionTapped() {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        }
    }
    
    @IBAction func postLocationToUdacity() {
        startAnimate(true)
        let objectId = dataDto?.objectId ?? ""
        if objectId.count > 0 {
            UdacityClient.updateStudentLocation(request: dataDto!, completion: self.handleLocationResponse(error:))
        } else {
            UdacityClient.addStudentLocation(request: dataDto!, completion: self.handleLocationResponse(error:))
        }
    }
    
    //MARK: Helper Methods
    func handleLocationResponse(error: ErrorResponse?) {
        startAnimate(false)
        if let error = error {
            ControllersUtil.presentAlert(controller: self, title: Errors.mainTitle, message: error.error)
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func navigateToLocation(annotation: MKPointAnnotation) {
        activityIndicator.startAnimating()
        mapView.addAnnotation(annotation)
        mapView.setCenter(annotation.coordinate, animated: true)
        mapView.selectAnnotation(annotation, animated: true)
        activityIndicator.stopAnimating()
    }
    
    func startAnimate(_ animate: Bool) {
        self.finishButton.isEnabled = !animate
        if animate {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}
