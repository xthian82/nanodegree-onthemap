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
    
    var locations: [StudentInformation] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.locations!
    }
    var annotations = [MKPointAnnotation]()
    
    //MARK: View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        loadLocations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView!.reloadInputViews()
    }
    
    @IBAction func reloadMap() {
        UdacityClient.getStudentLocations() { (locations, error) in
            if let error = error {
                ControllersUtil.presentAlert(controller: self, title: Errors.mainTitle, message: "\(Errors.cannotLoadLocations) \(error)")
            } else {
                self.reloadLocations()
            }
        }
    }
    
    //MARK: Map Actions
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.pinId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.pinId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
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
        for location in locations {
            annotations.append(getAnnotationFromInformation(location))
        }
        self.mapView.addAnnotations(annotations)
    }
    
    func reloadLocations() {
        self.mapView.removeAnnotations(annotations)
        annotations.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.locations = locations
        loadLocations()
        self.mapView.reloadInputViews()
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

