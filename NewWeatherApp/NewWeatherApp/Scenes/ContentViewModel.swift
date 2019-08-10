//
//  ContentViewModel.swift
//  NewWeatherApp
//
//  Created by Alessio Roberto on 09/08/2019.
//  Copyright © 2019 Alessio Roberto. All rights reserved.
//

import Foundation
import Combine

let myURL = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=milano&APPID=87503ac43c029650c30e680e36218cd5&units=metric")

struct Weather: Codable, Hashable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct OpenWeatherResponse: Codable, Hashable {
    let name: String
    let weather: [Weather]
}

let remoteDataPublisher = URLSession.shared.dataTaskPublisher(for: myURL!)
    // the dataTaskPublisher output combination is (data: Data, response: URLResponse)
    .map { $0.data }
    .decode(type: OpenWeatherResponse.self, decoder: JSONDecoder())

let cancellableSink = remoteDataPublisher
    .sink(receiveCompletion: { completion in
            print(".sink() received the completion", String(describing: completion))
            switch completion {
                case .finished:
                    break
                case .failure(let anError):
                    print("received error: ", anError)
            }
    }, receiveValue: { someValue in
        print(".sink() received \(someValue)")
    })
