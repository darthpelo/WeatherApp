//
//  CityWeather.swift
//  WeatherApp
//
//  Created by Alessio Roberto on 30/09/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Foundation
import Unbox

struct CityWeather {
    let id: Int
    let name: String
    let main: Main
    let weather: [Weather]
}

extension CityWeather: Unboxable {
    init(unboxer: Unboxer) throws {
        self.id = try unboxer.unbox(key: "id")
        self.name = try unboxer.unbox(key: "name")
        self.main = try unboxer.unbox(key: "main")
        self.weather = try unboxer.unbox(key: "weather")
    }
}

struct Main {
    let temp: Int
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
}

extension Main: Unboxable {
    init(unboxer: Unboxer) throws {
        self.temp = try unboxer.unbox(key: "temp")
        self.tempMin = try unboxer.unbox(key: "temp_min")
        self.tempMax = try unboxer.unbox(key: "temp_max")
        self.pressure = try unboxer.unbox(key: "pressure")
        self.humidity = try unboxer.unbox(key: "humidity")
    }
}

struct CityWeatherLight: Codable {
    let name: String
    let todayTemperature: Int
    let icon: String?
    let placeID: String
}

extension CityWeatherLight: Equatable {
    static func == (lhs: CityWeatherLight, rhs: CityWeatherLight) -> Bool {
        return
            lhs.name == rhs.name &&
                lhs.todayTemperature == rhs.todayTemperature &&
                lhs.icon == rhs.icon &&
                lhs.placeID == rhs.placeID
    }
}

struct CityWeatherDetail {
    let temp: Int
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
    
    init(main: Main) {
        self.temp = main.temp
        self.tempMin = main.tempMin
        self.tempMax = main.tempMax
        self.pressure = main.pressure
        self.humidity = main.humidity
    }
}
