//
//  MainPresenter.swift
//  WeatherApp
//
//  Created by Alessio Roberto on 29/09/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import GooglePlaces

protocol MainPresentable: class {
    func setupView()
    func loadCitySearch()
}

protocol MainViewable: class {
    func setDataSource(_ cities: [String])
    func presentAutocompleteController(_ autocompleteController: UIViewController)
    func dismiss()
}

import Foundation

final class MainPresenter: NSObject, MainPresentable {
    weak private var view: MainViewable?
    private var userDefaults: UserDefaults
    
    init(view: MainViewable, userDefaults: UserDefaults = UserDefaults.standard) {
        self.view = view
        self.userDefaults = userDefaults
    }
    
    func setupView() {
        guard let list = userDefaults.searchHistory as? [String] else {
            view?.setDataSource([])
            return
        }
        view?.setDataSource(list)
    }
    
    func loadCitySearch() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        view?.presentAutocompleteController(autocompleteController)
    }
    
    private func updateCitiesHistory(name: String) -> [String] {
        guard let list = userDefaults.searchHistory as? [String] else {
            userDefaults.searchHistory = [name]
            return [name]
        }
        
        var newList = list
        newList.append(name)
        userDefaults.searchHistory = newList
        return newList
    }
}

extension MainPresenter: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        view?.setDataSource(updateCitiesHistory(name: place.name))
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
