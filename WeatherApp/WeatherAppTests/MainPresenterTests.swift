//
//  MainPresenterTests.swift
//  WeatherAppTests
//
//  Created by Alessio Roberto on 28/09/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Moya
import UIKit
import XCTest

@testable import WeatherApp

class MainPresenterTests: XCTestCase {

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
    
    func testDeleteCity() {
        let mockView = MockMainViewController()
        let mockUserDefaults = UserDefaults(suiteName: "test")!
        let stubCity = CityWeatherLight(name: "Milan", todayTemperature: 23)
        
        let sut = MainPresenter(view: mockView, userDefaults: mockUserDefaults)
        
        mockUserDefaults.searchHistory = sut.convertToData([stubCity])
        
        sut.removeCity(at: 0)
        
        let result = sut.convertToCities(mockUserDefaults.searchHistory!)
        
        XCTAssertEqual(result!.count, 0)
    }

    func testGetCityName() {
        let mockView = MockMainViewController()
        let mockUserDefaults = UserDefaults(suiteName: "test")!
        let stubCity = CityWeatherLight(name: "Milan", todayTemperature: 23)
        
        let sut = MainPresenter(view: mockView, userDefaults: mockUserDefaults)
        
        mockUserDefaults.searchHistory = sut.convertToData([stubCity])
        
        let result = sut.getCityName(at: 0)
        
        XCTAssertEqual(result, "Milan")
    }
    
    func testSetupView() {
        let stubProvider = MoyaProvider<OpenWeather>(stubClosure: MoyaProvider.immediatelyStub)
        let mockView = MockMainViewController()
        let mockUserDefaults = UserDefaults(suiteName: "test")!
        let stubCity = CityWeatherLight(name: "Milan", todayTemperature: 23)
        let sut = MainPresenter(view: mockView, provider: stubProvider, userDefaults: mockUserDefaults)

        mockUserDefaults.searchHistory = sut.convertToData([stubCity])
        
        sut.setupView()
        
        XCTAssertTrue(mockView.setDataSourceCalled)
        
        let result = sut.updateCitiesHistory(name: "Amsterdam")
        XCTAssertEqual(result.count, 2)
    }

}

private final class MockMainViewController: UIViewController, MainViewable {
    var setDataSourceCallCount = 0
    var setDataSourceCalled: Bool {
        return setDataSourceCallCount > 0
    }
    func setDataSource(_ cities: [CityWeatherLight]) {
        setDataSourceCallCount += 1
    }
    
    var presentAutocompleteControllerCallCount = 0
    func presentAutocompleteController(_ autocompleteController: UIViewController) {
        presentAutocompleteControllerCallCount += 1
    }
    
    var dismissCallCount = 0
    func dismiss() {
        dismissCallCount += 1
    }
}
