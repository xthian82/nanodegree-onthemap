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
    var locations: [StudentInformation] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.locations!
    }
    
    //MARK: Window functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView!.reloadData()
    }
    
    //MARK: Action Buttons
    @IBAction func reloadInfo() {
        UdacityClient.getStudentLocations() { (locations, error) in
            if let error = error {
                ControllersUtil.presentAlert(controller: self, title: Errors.mainTitle, message: "\(Errors.cannotLoadLocations) \(error)")
            } else {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.locations = locations
                self.tableView!.reloadData()
            }
        }
    }
    
    //MARK: Table functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count
    }
       
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.locationDetail)!
        let locationDetail = self.locations[indexPath.row]
           
        // Set the name and image
        cell.textLabel?.text = "\(locationDetail.firstName) \(locationDetail.lastName)"
        cell.imageView?.image = UIImage(named: Constants.iconPin)
           
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let locationDetail = self.locations[indexPath.row]
        let toOpen = "\(locationDetail.mediaURL)" as String

        UIApplication.shared.open(URL(string: toOpen)!, options: [:]) { (success) in
            if !success {
                ControllersUtil.presentAlert(controller: self, title: Errors.mainTitle, message: Errors.cannotOpenUrl)
            }
        }
    }
}
