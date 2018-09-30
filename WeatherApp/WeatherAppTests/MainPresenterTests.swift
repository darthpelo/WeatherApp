//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Alessio Roberto on 28/09/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import UIKit
import XCTest

@testable import WeatherApp

class WeatherAppTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDismissView() {
        let mockView = MockMainViewController()
        let sut = MainPresenter(view: mockView)
        
        sut.loadCitySearch()
        
        XCTAssertEqual(mockView.presentAutocompleteControllerCallCount, 1)
    }
}

final class MockMainViewController: UIViewController, MainViewable {
    func setDataSource(_ cities: [CityWeatherLight]) {}
    
    var presentAutocompleteControllerCallCount = 0
    func presentAutocompleteController(_ autocompleteController: UIViewController) {
        presentAutocompleteControllerCallCount += 1
    }
    
    var dismissCallCount = 0
    func dismiss() {
        dismissCallCount += 1
    }
    
    
}
