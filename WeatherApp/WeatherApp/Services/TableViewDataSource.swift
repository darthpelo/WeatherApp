//
//  TableViewDataSource.swift
//  WeatherApp
//
//  Created by Alessio Roberto on 29/09/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Foundation
import UIKit

protocol RowUpdateProtocol: class {
    func removeModel(at: Int)
}

final class TableViewDataSource<Model>: NSObject, UITableViewDataSource {
    typealias CellConfigurator = (Model, UITableViewCell) -> Void
    
    weak var delegate: RowUpdateProtocol?
    
    fileprivate var models: [Model]
    
    private let reuseIdentifier: String
    private let cellConfigurator: CellConfigurator
    
    init(models: [Model],
         reuseIdentifier: String,
         cellConfigurator: @escaping CellConfigurator) {
        self.models = models
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: reuseIdentifier,
            for: indexPath
        )
        
        cellConfigurator(model, cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            models.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            delegate?.removeModel(at: indexPath.row)
        }
    }
}

extension TableViewDataSource where Model == CityWeatherLight {
    static func make(for cities: [CityWeatherLight],
                     reuseIdentifier: String = "CityCell") -> TableViewDataSource {
        return TableViewDataSource(
            models: cities,
            reuseIdentifier: reuseIdentifier
        ) { city, cell in
            guard let cityCell = cell as? CityTableViewCell else {
                return
            }
            
            cityCell.cityNameLabel.text = city.name
            cityCell.temperatureLabel.text = "\(city.todayTemperature) ℃"
            cityCell.iconImage.load(url: URL(string: "http://openweathermap.org/img/w/\(city.icon ?? "").png")!) // swiftlint:disable:this force_unwrapping
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
