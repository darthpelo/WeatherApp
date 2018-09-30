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
    
    private func citiesDidLoad(_ cities: [CityWeatherLight]) {
        dataSource = .make(for: cities)
        tableView.dataSource = dataSource
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
}

extension MainViewController: MainViewable {
    func setDataSource(_ cities: [CityWeatherLight]) {
        citiesDidLoad(cities)
    }
    
    func presentAutocompleteController(_ autocompleteController: UIViewController) {
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}
