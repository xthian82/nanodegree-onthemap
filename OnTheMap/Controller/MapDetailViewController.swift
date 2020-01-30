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
    var matchingItems:[MKMapItem] = []
    var currentLocation: MKPointAnnotation?
    var dataDto: RequestDto?
    @IBOutlet weak var finishButton: RoundButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: Navigation Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        enableSubmit(false)
        searchPlace()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: Map Functions
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return ControllersUtil.getPinViewFromMap(mapView, annotation: annotation, identifier: Constants.pinId)
    }
    
    //MARK: Action Buttons
    func searchPlace() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = self.dataDto?.locationMap
        request.region = self.mapView.region

        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                ControllersUtil.presentAlert(controller: self, title: Errors.locationErrorTitle, message: Errors.findLocationProblem)
                return
            }
            self.enableSubmit(true)
            self.currentLocation = self.getAnnotationFromMapItem(response.mapItems[0])
            self.navigateToLocation(annotation: self.currentLocation!)
        }
    }
    
    @IBAction func cancelActionTapped() {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        }
    }
    
    @IBAction func postLocationToUdacity() {
        enableSubmit(false)
        self.activityIndicator.startAnimating()
        let objectId = dataDto?.objectId ?? ""
        if objectId.count > 0 {
            UdacityClient.updateStudentLocation(request: dataDto!, completion: self.handleLocationResponse(error:))
        } else {
            UdacityClient.addStudentLocation(request: dataDto!, completion: self.handleLocationResponse(error:))
        }
    }
    
    //MARK: Helper Methods
    func handleLocationResponse(error: ErrorResponse?) {
        self.activityIndicator.stopAnimating()
        enableSubmit(true)
        if let error = error {
            ControllersUtil.presentAlert(controller: self, title: Errors.mainTitle, message: error.error)
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func navigateToLocation(annotation: MKPointAnnotation) {
        self.mapView.addAnnotation(annotation)
        self.mapView.setCenter(annotation.coordinate, animated: true)
        self.mapView.selectAnnotation(annotation, animated: true)
        self.dataDto!.longitude = annotation.coordinate.longitude
        self.dataDto!.latitude = annotation.coordinate.latitude
    }
    
    func getAnnotationFromMapItem(_ mapItem: MKMapItem) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapItem.placemark.coordinate
        annotation.title = mapItem.name
        return annotation
    }
    
    func enableSubmit(_ enabled: Bool) {
        self.finishButton.isEnabled = enabled
    }
}
