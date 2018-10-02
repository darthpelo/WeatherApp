//
//  MainPresenter.swift
//  WeatherApp
//
//  Created by Alessio Roberto on 29/09/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Foundation
import GooglePlaces
import Moya
import Unbox

protocol MainPresentable: class {
    func setupView()
    func loadCitySearch()
    func removeCity(at index: Int)
    func getCityName(at index: Int) -> (name: String, placeID: String)?
}

protocol MainViewable: class {
    func setDataSource(_ cities: [CityWeatherLight])
    func presentAutocompleteController(_ autocompleteController: UIViewController)
    func dismiss()
}

final class MainPresenter: NSObject, MainPresentable {
    weak internal var view: MainViewable?
    
    private var userDefaults: UserDefaults
    private var provider: MoyaProvider<OpenWeather>
    
    init(view: MainViewable,
         provider: MoyaProvider<OpenWeather> = openWeather,
         userDefaults: UserDefaults = UserDefaults.standard) {
        self.view = view
        self.provider = provider
        self.userDefaults = userDefaults
    }
    
    func setupView() {
        guard let data = userDefaults.searchHistory,
            let list = convertToCities(data) else {
                view?.setDataSource([])
                return
        }
        reloadCitiesTemperature(list: list)
        view?.setDataSource(list)
    }
    
    func loadCitySearch() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        view?.presentAutocompleteController(autocompleteController)
    }
    
    func removeCity(at index: Int) {
        guard let data = userDefaults.searchHistory,
            let list = convertToCities(data) else {
                return
        }
        
        var newList = list
        newList.remove(at: index)
        userDefaults.searchHistory = convertToData(newList)
    }
    
    func getCityName(at index: Int) -> (name: String, placeID: String)? {
        guard let data = userDefaults.searchHistory,
            let list = convertToCities(data) else {
                return nil
        }
        
        return (list[index].name, list[index].placeID)
    }
    
    func convertToCities(_ data: Data) -> [CityWeatherLight]? {
        let decoder = JSONDecoder()
        return try? decoder.decode([CityWeatherLight].self, from: data)
    }
    
    func convertToData<T: Equatable&Codable>(_ list: [T]) -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(list)
    }
    
    // MARK: - Private
    internal func updateCitiesHistory(name: String, placeID: String) -> [CityWeatherLight] {
        guard let data = userDefaults.searchHistory,
            let list = convertToCities(data) else {
                let firstCity = CityWeatherLight(name: name, todayTemperature: 0, placeID: placeID)
                userDefaults.searchHistory = convertToData([firstCity])
                return [firstCity]
        }
        
        var newList = list
        newList.insert(CityWeatherLight(name: name, todayTemperature: 0, placeID: placeID), at: 0)
        reloadCitiesTemperature(list: newList)
        userDefaults.searchHistory = convertToData(newList)
        return newList
    }
    
    private func reloadCitiesTemperature(list: [CityWeatherLight]) {
        var newList = list
        var idx = 0
        for city in list {
            provider.request(.weather(city: city.name)) { [weak self, idx, city] result in
                guard let self = self else { return }
                
                switch result {
                case let .success(moyaResponse):
                    do {
                        let data = try moyaResponse.mapJSON()
                        if let dictionary = data as? Dictionary<String, Any> {
                            let item: CityWeather? = try? unbox(dictionary: dictionary)
                            guard let temperature = item?.main.temp else {
                                return
                            }
                            let newData = CityWeatherLight(name: city.name,
                                                           todayTemperature: temperature,
                                                           placeID: city.placeID)
                            if city != newData {
                                newList.remove(at: idx)
                                newList.insert(newData, at: idx)
                                self.view?.setDataSource(newList)
                                self.userDefaults.searchHistory = self.convertToData(newList)
                            }
                        }
                    } catch {
                        
                    }
                case let .failure(error):
                    print("Error: ", error.localizedDescription)
                }
                
            }
            idx += 1
        }
    }
}
