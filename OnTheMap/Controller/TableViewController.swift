//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Cristhian Recalde on 1/26/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {
    
    //MARK: Properties
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: Window functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: Action Buttons
    @IBAction func reloadInfo() {
        activityIndicator.startAnimating()
        UdacityClient.getStudentLocations() { (locations, error) in
            self.activityIndicator.stopAnimating()
            if let error = error {
                ControllersUtil.presentAlert(controller: self, title: Errors.mainTitle, message: "\(Errors.cannotLoadLocations) \(error)")
            } else {
                LocationManager.shared.locations = locations
                self.tableView!.reloadData()
            }
        }
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        logginOut(sender, activityIndicator: activityIndicator)
    }
    
    @IBAction func postLocationTableTapped(_ sender: UIBarButtonItem) {
        navigateToPostLocation(sender, activityIndicator: activityIndicator)
    }
    
    //MARK: Table functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocationManager.shared.locations.count
    }
       
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.locationDetail)!
        let locationDetail = LocationManager.shared.locations[indexPath.row]
           
        // Set the name and image
        cell.textLabel?.text = "\(locationDetail.firstName) \(locationDetail.lastName)"
        cell.imageView?.image = UIImage(named: Constants.iconPin)
           
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let locationDetail = LocationManager.shared.locations[indexPath.row]
        let toOpen = "\(locationDetail.mediaURL)" as String

        UIApplication.shared.open(URL(string: toOpen)!, options: [:]) { (success) in
            if !success {
                ControllersUtil.presentAlert(controller: self, title: Errors.mainTitle, message: Errors.cannotOpenUrl)
            }
        }
    }
}
