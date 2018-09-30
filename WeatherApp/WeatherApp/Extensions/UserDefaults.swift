//
//  UserDefaults.swift
//  WeatherApp
//
//  Created by Alessio Roberto on 29/09/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Foundation

extension UserDefaults {
    var searchHistory: Data? {
        get { return data(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
}
