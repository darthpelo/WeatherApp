//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Alessio Roberto on 28/09/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import GooglePlaces
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSPlacesClient.provideAPIKey("AIzaSyBwRUPIOAjj4YlU0M6KRgpbJVZbQsdseu0")
        
        return true
    }

}
