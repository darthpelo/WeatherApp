//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Alessio Roberto on 29/09/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    lazy var presenter: MainPresentable = MainPresenter(view: self)
    
    private var dataSource: TableViewDataSource<CityWeatherLight>?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.setupView()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        presenter.loadCitySearch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "ShowCityDetail",
            let detailVC = segue.destination as? CityDetailViewController,
            let idx = tableView.indexPathForSelectedRow?.row {
            detailVC.cityName = presenter.getCityName(at: idx)
        }
    }
    
    // MARK: - Private
    internal func citiesDidLoad(_ cities: [CityWeatherLight]) {
        dataSource = .make(for: cities)
        tableView.dataSource = dataSource
        dataSource?.delegate = self
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
}
