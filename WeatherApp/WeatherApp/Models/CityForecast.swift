//
//  CityForecast.swift
//  WeatherApp
//
//  Created by Alessio Roberto on 30/09/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Foundation
import Unbox

struct CityForecast {
    let days: [Forecast]
}

extension CityForecast: Unboxable {
    init(unboxer: Unboxer) throws {
        self.days = try unboxer.unbox(key: "list")
    }
}

struct Forecast {
    let timeStamp: Double
    let main: Main
    let weather: [Weather]
}

extension Forecast: Unboxable {
    init(unboxer: Unboxer) throws {
        self.timeStamp = try unboxer.unbox(key: "dt")
        self.main = try unboxer.unbox(key: "main")
        self.weather = try unboxer.unbox(key: "weather")
    }
}

struct Weather {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

extension Weather: Unboxable {
    init(unboxer: Unboxer) throws {
        self.id = try unboxer.unbox(key: "id")
        self.main = try unboxer.unbox(key: "main")
        self.description = try unboxer.unbox(key: "description")
        self.icon = try unboxer.unbox(key: "icon")
    }
}

struct DayForecastLight {
    let timeStamp: Double
    let temperature: Int
    let icon: String
    
    init(_ forecast: Forecast) {
        self.timeStamp = forecast.timeStamp
        self.temperature = forecast.main.temp
        self.icon = forecast.weather.first?.icon ?? ""
    }
}
