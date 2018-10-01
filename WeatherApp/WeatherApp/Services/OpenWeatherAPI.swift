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
    case forecast(city: String)
}

extension OpenWeather: TargetType {
    public var baseURL: URL { return URL(string: "https://api.openweathermap.org/data/2.5")! } // swiftlint:disable:this force_unwrapping
    
    public var path: String {
        switch self {
        case .weather:
            return "/weather"
        case .forecast:
            return "/forecast"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .weather,
             .forecast:
            return .get
        }
    }
    
    public var sampleData: Data {
        return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)! // swiftlint:disable:this force_unwrapping
    }
    
    public var task: Task {
        switch self {
        case .weather(let city):
            return .requestParameters(parameters: ["q": city,
                                                   "APPID": "87503ac43c029650c30e680e36218cd5",
                                                   "units": "metric", ],
                                      encoding: URLEncoding.queryString)
        case .forecast(let city):
            return .requestParameters(parameters: ["q": city,
                                                   "APPID": "87503ac43c029650c30e680e36218cd5",
                                                   "units": "metric", ],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String: String]? {
        return nil
    }
    
}
