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
    
    var locations: [StudentLocation] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.locations
    }
    
    //MARK: View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for dict in locations {
            annotations.append(getAnnotationFromDictionary(dict))
        }
        self.mapView.delegate = self
        self.mapView.addAnnotations(annotations)
    }
    
    @IBAction func reloadMap() {
        self.mapView.reloadInputViews()
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
                UIApplication.shared.open(URL(string: toOpen)!, options: [:]) { (success) in
                    if !success {
                        let alert = ControllersUtil.getDefaultFailureUI(title: "Wrong Url!", message: "Cannot open the url provided")
                        //self.show(alert, sender: nil)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }

    // MARK: Helper method
    func getAnnotationFromDictionary(_ studentLocation: StudentLocation) -> MKPointAnnotation {
        
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

