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
    
    var locations: [[String: Any]] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.locations
    }
    
    //MARK: View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let locations = hardCodedLocationData()
        
        for dict in locations {
            annotations.append(getAnnotationFromDictionary(dict))
        }
        self.mapView.delegate = self
        self.mapView.addAnnotations(annotations)
    }
    
    //MARK: Map Actions
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: Keys.pinId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Keys.pinId)
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
                UIApplication.shared.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }

    // MARK: - Sample Data
    func getAnnotationFromDictionary(_ dictionary: [String: Any]) -> MKPointAnnotation {
        
        // The lat and long are used to create a CLLocationCoordinates2D instance.
        let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(dictionary[Keys.latitude] as! Double),
                                                longitude: CLLocationDegrees(dictionary[Keys.longitude] as! Double))
        
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(dictionary[Keys.firstName] ?? "") \(dictionary[Keys.lastName] ?? "")"
        annotation.subtitle = "\(dictionary[Keys.mediaURL] ?? "")"
        
        return annotation
    }
    
 
}

