//
//  AppDelegate.swift
//  OnTheMap
//
//  Created by Cristhian Recalde on 1/24/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let locations = hardCodedLocationData()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // Some sample data. This is a dictionary that is more or less similar to the
     // JSON data that you will download from Parse.
     
     class func hardCodedLocationData() -> [StudentInformation] {
         return  [
            StudentInformation(createdAt: "2015-02-24T22:27:14.456Z",
                            firstName: "Jessica",
                            lastName: "Uelmen",
                            latitude: 28.1461248,
                            longitude: -82.75676799999999,
                            mapString: "Tarpon Springs, FL",
                            mediaURL: "www.linkedin.com/in/jessicauelmen/en",
                            objectId: "kj18GEaWD8",
                            uniqueKey: "872458750",
                            updatedAt: "2015-03-09T22:07:09.593Z"),
            
            StudentInformation(createdAt: "2015-02-24T22:35:30.639Z",
                            firstName: "Gabrielle",
                            lastName: "Miller-Messner",
                            latitude: 35.1740471,
                            longitude: -79.3922539,
                            mapString: "Southern Pines, NC",
                            mediaURL: "http://www.linkedin.com/pub/gabrielle-miller-messner/11/557/60/en",
                            objectId: "8ZEuHF5uX8",
                            uniqueKey: "2256298598",
                            updatedAt: "2015-03-11T03:23:49.582Z"),
            
            StudentInformation(createdAt: "2015-02-24T22:30:54.442Z",
                            firstName: "Jason",
                            lastName: "Schatz",
                            latitude: 37.7617,
                            longitude: -122.4216,
                            mapString: "18th and Valencia, San Francisco, CA",
                            mediaURL: "http://en.wikipedia.org/wiki/Swift_%28programming_language%29",
                            objectId: "hiz0vOTmrL",
                            uniqueKey: "2362758535",
                            updatedAt: "2015-03-10T17:20:31.828Z"),
            
            StudentInformation(createdAt: "2015-03-11T02:48:18.321Z",
                            firstName: "Jarrod",
                            lastName: "Parkes",
                            latitude: 34.73037,
                            longitude: -86.58611000000001,
                            mapString: "Huntsville, Alabama",
                            mediaURL: "https://linkedin.com/in/jarrodparkes",
                            objectId: "CDHfAy8sdp",
                            uniqueKey: "996618664",
                            updatedAt: "2015-03-13T03:37:58.389Z")
         ]
     }
}

