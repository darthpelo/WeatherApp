//
//  TableViewDataSourceExtensions.swift
//  WeatherApp
//
//  Created by Alessio Roberto on 01/10/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Foundation

extension TableViewDataSource where Model == CityWeatherLight {
    static func make(for cities: [CityWeatherLight],
                     reuseIdentifier: String = "CityCell") -> TableViewDataSource {
        return TableViewDataSource(
            models: cities,
            reuseIdentifier: reuseIdentifier
        ) { city, cell in
            cell.textLabel?.text = city.name
            cell.detailTextLabel?.text = "\(city.todayTemperature) ℃"
        }
    }
}

extension TableViewDataSource where Model == DayForecastLight {
    static func make(for days: [DayForecastLight],
                     reuseIdentifier: String = "DayCell") -> TableViewDataSource {
        return TableViewDataSource(
            models: days,
            reuseIdentifier: reuseIdentifier
        ) { day, cell in
            guard let dayCell = cell as? DayTableViewCell else {
                return
            }
            
            let date = DateFormatter.localizedString(from: Date(timeIntervalSince1970: day.timeStamp),
                                                     dateStyle: .medium,
                                                     timeStyle: .short)
            dayCell.dateLabel.text = date
            dayCell.temperatureLabel.text = "\(day.temperature) ℃"
            dayCell.iconImageView.load(url: URL(string: "http://openweathermap.org/img/w/\(day.icon).png")!) // swiftlint:disable:this force_unwrapping
        }
    }
}
