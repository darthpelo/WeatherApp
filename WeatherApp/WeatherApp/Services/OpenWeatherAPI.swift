//
//  OpenWeatherAPI.swift
//  WeatherApp
//
//  Created by Alessio Roberto on 29/09/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Foundation
import Moya

let openWeather = MoyaProvider<OpenWeather>()

public enum OpenWeather {
    case weather(city: String)
}

extension OpenWeather: TargetType {
    public var baseURL: URL { return URL(string: "https://api.openweathermap.org")! } // swiftlint:disable:this force_unwrapping
    
    public var path: String {
        switch self {
        case .weather:
            return "/data/2.5/weather"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .weather:
            return .get
        }
    }
    
    public var sampleData: Data {
        return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        switch self {
        case .weather(let city):
            return .requestParameters(parameters: ["q": city,
                                                   "APPID": "87503ac43c029650c30e680e36218cd5",
                                                   "units": "metric"],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
}
