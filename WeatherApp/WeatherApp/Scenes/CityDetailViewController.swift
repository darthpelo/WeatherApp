//
//  CityDetailViewController.swift
//  WeatherApp
//
//  Created by Alessio Roberto on 30/09/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import UIKit

class CityDetailViewController: UIViewController {
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var cityName: String?
    lazy var presenter: CityDetailPresentable = CityDetailPresenter(view: self)
    private var dataSource: TableViewDataSource<DayForecastLight>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = cityName
        
        dayForecastDidLoad([])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let city = cityName else { return }
        
        presenter.setupUI(withCity: city)
    }
    
    // MARK: - Private
    internal func dayForecastDidLoad(_ days: [DayForecastLight]) {
        dataSource = .make(for: days)
        tableView.dataSource = dataSource
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
}

extension CityDetailViewController: CityDetailView {
    func updateForecast(with forecast: [DayForecastLight]) {
        dayForecastDidLoad(forecast)
    }
    
    func updateTopView(with weather: CityWeatherDetail) {
        tempLabel.text = "\(weather.temp) ℃"
        tempMinLabel.text = "\(weather.tempMin) ℃"
        tempMaxLabel.text = "\(weather.tempMax) ℃"
        pressureLabel.text = "\(weather.pressure) hPa"
        humidityLabel.text = "\(weather.humidity)%"
    }

}
