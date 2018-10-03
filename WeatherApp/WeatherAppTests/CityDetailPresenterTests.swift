//
//  CityDetailPresenterTests.swift
//  WeatherAppTests
//
//  Created by Alessio Roberto on 01/10/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Moya
import UIKit
import XCTest

@testable import WeatherApp

class CityDetailPresenterTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSetupUI() {
        let stubProvider = MoyaProvider<OpenWeather>(stubClosure: MoyaProvider.immediatelyStub)
        let mockView = MockCityDetailViewController()
        
        let sut = CityDetailPresenter(view: mockView, provider: stubProvider)
        
        sut.setupUI(withCity: "Amsterdam")
        
        XCTAssertEqual(1, mockView.updateTopViewCallCount)
        XCTAssertEqual(1, mockView.updateForecastCallcount)
    }
    
    func testLoadImageFails() {
        let stubProvider = MoyaProvider<OpenWeather>(stubClosure: MoyaProvider.immediatelyStub)
        let mockView = MockCityDetailViewController()
        
        let sut = CityDetailPresenter(view: mockView, provider: stubProvider)
        
        sut.loadFirstPhotoForPlace(placeID: "")
        
        XCTAssertEqual(0, mockView.updateBackgroundImageCallCount)
    }
}

private final class MockCityDetailViewController: UIViewController, CityDetailView {
    var updateBackgroundImageCallCount = 0
    func updateBackgroundImage(with image: UIImage?) {
        updateBackgroundImageCallCount += 1
    }
    
    var updateTopViewCallCount = 0
    func updateTopView(with weather: CityWeatherDetail) {
        updateTopViewCallCount += 1
    }
    
    var updateForecastCallcount = 0
    func updateForecast(with forecast: [DayForecastLight]) {
        updateForecastCallcount += 1
    }
}
