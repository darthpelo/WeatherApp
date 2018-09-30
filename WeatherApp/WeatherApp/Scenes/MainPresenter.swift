//
//  MainPresenter.swift
//  WeatherApp
//
//  Created by Alessio Roberto on 29/09/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import GooglePlaces
import Moya
import Unbox

protocol MainPresentable: class {
    func setupView()
    func loadCitySearch()
    func removeCity(at index: Int)
}

protocol MainViewable: class {
    func setDataSource(_ cities: [CityWeatherLight])
    func presentAutocompleteController(_ autocompleteController: UIViewController)
    func dismiss()
}

import Foundation

final class MainPresenter: NSObject, MainPresentable {
    weak private var view: MainViewable?
    private var userDefaults: UserDefaults
    
    init(view: MainViewable, userDefaults: UserDefaults = UserDefaults.standard) {
        self.view = view
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
    
    private func updateCitiesHistory(name: String) -> [CityWeatherLight] {
        guard let data = userDefaults.searchHistory,
            let list = convertToCities(data) else {
                let firstCity = CityWeatherLight(name: name, todayTemperature: 0)
                userDefaults.searchHistory = convertToData([firstCity])
                return [firstCity]
        }
        
        var newList = list
        newList.insert(CityWeatherLight(name: name, todayTemperature: 0), at: 0)
        reloadCitiesTemperature(list: newList)
        userDefaults.searchHistory = convertToData(newList)
        return newList
    }
    
    private func reloadCitiesTemperature(list: [CityWeatherLight]) {
        var newList = list
        var idx = 0
        for city in list {
            openWeather.request(.weather(city: city.name)) { [weak self, idx] result in
                guard let self = self else { return }
                
                switch result {
                case let .success(moyaResponse):
                    do {
                        let data = try moyaResponse.mapJSON()
                        if let dictionary = data as? Dictionary<String, Any> {
                            let item: CityWeather? = try? unbox(dictionary: dictionary)
                            guard let name = item?.name, let temperature = item?.main.temp else {
                                return
                            }
                            let newData = CityWeatherLight(name: name, todayTemperature: temperature)
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
    
    func convertToCities(_ data: Data) -> [CityWeatherLight]? {
        let decoder = JSONDecoder()
        return try? decoder.decode([CityWeatherLight].self, from: data)
    }
    
    func convertToData<T: Equatable&Codable>(_ list: [T]) -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(list)
    }
}

extension MainPresenter: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        view?.setDataSource(updateCitiesHistory(name: place.name))
        view?.dismiss()
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
        view?.dismiss()
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        view?.dismiss()
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
