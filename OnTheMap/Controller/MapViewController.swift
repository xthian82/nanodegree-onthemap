//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Cristhian Recalde on 1/24/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    //MARK: Properties
    @IBOutlet weak var mapView: MKMapView!
    var annotations = [MKPointAnnotation]()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadLocations()
        tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func reloadMap() {
        activityIndicator.startAnimating()
        UdacityClient.getStudentLocations() { (locations, error) in
            self.activityIndicator.stopAnimating()
            if let error = error {
                ControllersUtil.presentAlert(controller: self, title: Errors.mainTitle, message: "\(Errors.cannotLoadLocations) \(error)")
            } else {
                LocationManager.shared.locations = locations
                self.loadLocations()
            }
        }
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        logginOut(sender, activityIndicator: activityIndicator)
    }
    
    @IBAction func postLocationMapTapped(_ sender: UIBarButtonItem) {
        navigateToPostLocation(sender, activityIndicator: activityIndicator)
    }
    
    //MARK: Map Actions
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return ControllersUtil.getPinViewFromMap(mapView, annotation: annotation, identifier: Constants.pinId)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                UIApplication.shared.open(URL(string: toOpen)!, options: [:]) { (success) in
                    if !success {
                        ControllersUtil.presentAlert(controller: self, title: Errors.mainTitle, message: Errors.cannotOpenUrl)
                    }
                }
            }
        }
    }

    // MARK: Helper method
    func loadLocations() {
        mapView.removeAnnotations(annotations)
        annotations.removeAll()
        for location in LocationManager.shared.locations {
            annotations.append(getAnnotationFromInformation(location))
        }
        mapView.addAnnotations(annotations)
    }
    
    func getAnnotationFromInformation(_ studentLocation: StudentInformation) -> MKPointAnnotation {
        
        // The lat and long are used to create a CLLocationCoordinates2D instance.
        let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(studentLocation.latitude),
                                                longitude: CLLocationDegrees(studentLocation.longitude))
        
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(studentLocation.firstName) \(studentLocation.lastName)"
        annotation.subtitle = "\(studentLocation.mediaURL)"
        
        return annotation
    }
}

