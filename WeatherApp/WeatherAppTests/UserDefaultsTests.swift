//
//  UserDefaultsTests.swift
//  WeatherAppTests
//
//  Created by Alessio Roberto on 29/09/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import XCTest

@testable import WeatherApp

class UserDefaultsTests: XCTestCase {
    private let stubCity = CityWeatherLight(name: "Milan", todayTemperature: 23, icon: nil, placeID: "")
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    private func convertToCities(_ data: Data) -> [CityWeatherLight]? {
        let decoder = JSONDecoder()
        return try? decoder.decode([CityWeatherLight].self, from: data)
    }
    
    private func convertToData<T: Equatable&Codable>(_ list: [T]) -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(list)
    }
    
    func testSetGet() {
        let sut = UserDefaults(suiteName: "test")
        
        sut?.searchHistory = convertToData([stubCity])
        
        let getResult = convertToCities((sut?.searchHistory)!)
        
        XCTAssertNotNil(getResult)
        XCTAssertEqual([stubCity], getResult!)
    }
}
