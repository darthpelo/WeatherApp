//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Alessio Roberto on 29/09/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import GooglePlaces
import UIKit

class MainViewController: UIViewController, UITableViewDelegate {
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
            detailVC.city = presenter.getCityName(at: idx)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowCityDetail", sender: nil)
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

extension MainViewController: MainViewable, RowUpdateProtocol {
    func setDataSource(_ cities: [CityWeatherLight]) {
        citiesDidLoad(cities)
    }
    
    func presentAutocompleteController(_ autocompleteController: UIViewController) {
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    func removeModel(at: Int) {
        presenter.removeCity(at: at)
    }
}

extension MainPresenter: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        view?.setDataSource(updateCitiesHistory(name: place.name, placeID: place.placeID))
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
