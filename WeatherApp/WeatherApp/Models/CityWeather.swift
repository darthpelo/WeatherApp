//
//  CityWeather.swift
//  WeatherApp
//
//  Created by Alessio Roberto on 30/09/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Foundation
import Unbox

public struct CityWeather {
    public let id: Int
    public let name: String
    public let main: Main
}

extension CityWeather: Unboxable {
    public init(unboxer: Unboxer) throws {
        self.id = try unboxer.unbox(key: "id")
        self.name = try unboxer.unbox(key: "name")
        self.main = try unboxer.unbox(key: "main")
    }
}

public struct Main {
    public let temp: Double
}

extension Main: Unboxable {
    public init(unboxer: Unboxer) throws {
        self.temp = try unboxer.unbox(key: "temp")
    }
}

struct CityWeatherLight: Codable {
    let name: String
    let todayTemperature: Double
}

extension CityWeatherLight: Equatable {
    static func == (lhs: CityWeatherLight, rhs: CityWeatherLight) -> Bool {
        return
            lhs.name == rhs.name &&
                lhs.todayTemperature == rhs.todayTemperature
    }
}
