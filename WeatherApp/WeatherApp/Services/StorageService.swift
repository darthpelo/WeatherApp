//
//  StorageService.swift
//  WeatherApp
//
//  Created by Alessio Roberto on 02/10/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Foundation

protocol Storageable {
    func loadHistory() -> [CityWeatherLight]?
    func store(history: [CityWeatherLight])
}

struct StorageService: Storageable {
    private var userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    func store(history: [CityWeatherLight]) {
        userDefaults.searchHistory = convertToData(history)
    }
    
    func loadHistory() -> [CityWeatherLight]? {
        guard let data = userDefaults.searchHistory,
            let history = convertToCities(data) else {
                return nil
        }
        
        return history
    }
    
    // MARK: - Private
    private func convertToCities(_ data: Data) -> [CityWeatherLight]? {
        let decoder = JSONDecoder()
        return try? decoder.decode([CityWeatherLight].self, from: data)
    }
    
    private func convertToData<T: Equatable&Codable>(_ list: [T]) -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(list)
    }
}
