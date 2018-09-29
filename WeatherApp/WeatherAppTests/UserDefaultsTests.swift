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
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSetGet() {
        let sut = UserDefaults(suiteName: "test")
        
        let list = ["Milan", "Amsterdam", "London"]
        
        sut?.searchHistory = list
        
        let getResult = sut?.searchHistory as? [String]
        
        XCTAssertNotNil(getResult)
        XCTAssertEqual(list, getResult!)
    }
}
