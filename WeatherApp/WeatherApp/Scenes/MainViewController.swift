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
    
    private var dataSource: TableViewDataSource<String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.setupView()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        presenter.loadCitySearch()
    }
    
    private func citiesDidLoad(_ cities: [String]) {
        dataSource = .make(for: cities)
        tableView.dataSource = dataSource
    }
}

extension MainViewController: MainViewable {
    func setDataSource(_ cities: [String]) {
        citiesDidLoad(cities)
    }
    
    func presentAutocompleteController(_ autocompleteController: UIViewController) {
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}
