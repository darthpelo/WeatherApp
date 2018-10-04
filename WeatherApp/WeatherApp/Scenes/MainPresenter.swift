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
    
    private var storage: Storageable
    private var provider: MoyaProvider<OpenWeather>
    
    init(view: MainViewable,
         provider: MoyaProvider<OpenWeather> = openWeather,
         storage: Storageable = StorageService()) {
        self.view = view
        self.provider = provider
        self.storage = storage
    }
    
    func setupView() {
        guard let list = storage.loadHistory() else {
            view?.setDataSource([])
            return
        }
        
        view?.setDataSource(list)
        
        updateCitiesHistoryTemperature()
    }
    
    func loadCitySearch() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        view?.presentAutocompleteController(autocompleteController)
    }
    
    func removeCity(at index: Int) {
        guard let list = storage.loadHistory() else {
            return
        }
        
        var newList = list
        newList.remove(at: index)
        storage.store(history: newList)
    }
    
    func getCityName(at index: Int) -> (name: String, placeID: String)? {
        guard let list = storage.loadHistory() else {
            return nil
        }
        
        return (list[index].name, list[index].placeID)
    }
    
    // MARK: - Private
    internal func updateCitiesHistory(name: String, placeID: String) -> [CityWeatherLight] {
        guard let list = storage.loadHistory() else {
            let firstCity = CityWeatherLight(name: name, todayTemperature: 0, icon: nil, placeID: placeID)
            storage.store(history: [firstCity])
            return [firstCity]
        }
        
        var newList = list
        
        newList.insert(CityWeatherLight(name: name, todayTemperature: 0, icon: nil, placeID: placeID), at: 0)
        
        storage.store(history: newList)
        
        updateCitiesHistoryTemperature()
        
        return newList
    }
    
    private func updateCitiesHistoryTemperature() {
        guard let list = storage.loadHistory() else { return }
        
        var newList = list
        var idx = 0
        
        for city in list {
            provider.request(.weather(city: city.name)) { [weak self, idx, city] result in
                guard let self = self else { return }
                
                switch result {
                case let .success(moyaResponse):
                    self.manageCitiesHistory(moyaResponse, &newList, city, cityIndex: idx)
                case let .failure(error):
                    print("Error: ", error.localizedDescription)
                }
            }
            idx += 1
        }
    }
    
    private func manageCitiesHistory(_ moyaResponse: (Response),
                                     _ newList: inout [CityWeatherLight],
                                     _ city: CityWeatherLight,
                                     cityIndex: Int) {
        if let cityUpdate = makeCityWeatherLight(response: moyaResponse, city: city) {
            newList.remove(at: cityIndex)
            newList.insert(cityUpdate, at: cityIndex)
            view?.setDataSource(newList)
            
            storage.store(history: newList)
        }
    }
    
    private func makeCityWeatherLight(response: Response, city: CityWeatherLight) -> CityWeatherLight? {
        do {
            let data = try response.mapJSON()
            
            guard let dictionary = data as? [String: Any] else {
                return nil
            }
            
            let item: CityWeather? = try? unbox(dictionary: dictionary)
            
            guard let temperature = item?.main.temp else {
                return nil
            }
            
            return CityWeatherLight(name: city.name,
                                    todayTemperature: temperature,
                                    icon: item?.weather.first?.icon,
                                    placeID: city.placeID)
        } catch {
            return nil
        }
    }
}
