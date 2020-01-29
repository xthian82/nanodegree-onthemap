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
    var location: String = ""
    var mediaURL: String = ""
    
    //MARK: Navigation Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
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
        let reuseId = Constants.pinId
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    //MARK: Action Buttons
    func searchPlace() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = self.location
        request.region = self.mapView.region

        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                ControllersUtil.presentAlert(controller: self, title: Errors.locationErrorTitle, message: Errors.findLocationProblem)
                return
            }
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
        print("post tapped")
    }
    
    //MARK: Helper Methods
    func navigateToLocation(annotation: MKPointAnnotation) {
        self.mapView.addAnnotation(annotation)
        self.mapView.setCenter(annotation.coordinate, animated: true)
        self.mapView.selectAnnotation(annotation, animated: true)
    }
    
    func getAnnotationFromMapItem(_ mapItem: MKMapItem) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapItem.placemark.coordinate
        annotation.title = mapItem.name
        return annotation
    }
}
