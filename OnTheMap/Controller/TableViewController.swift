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
    
    var locations: [[String: Any]] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.locations
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView!.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count
    }
       
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Keys.locationDetail)!
        let locationDetail = self.locations[indexPath.row]
           
        // Set the name and image
        cell.textLabel?.text = "\(locationDetail[Keys.firstName] ?? "") \(locationDetail[Keys.lastName] ?? "")"
        cell.imageView?.image = UIImage(named: "icon_pin")
           
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let locationDetail = self.locations[indexPath.row]
        let toOpen = "\(locationDetail[Keys.mediaURL] ?? "")" as String
        
        if toOpen.count > 0 {
            UIApplication.shared.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
        } else {
            print("NO URL FOUND")
        }
    }
}
