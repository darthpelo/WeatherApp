//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Alessio Roberto on 01/10/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Foundation
import UIKit

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

extension MainViewController: RowUpdateProtocol {
    func removeModel(at: Int) {
        presenter.removeCity(at: at)
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowCityDetail", sender: nil)
    }
}
