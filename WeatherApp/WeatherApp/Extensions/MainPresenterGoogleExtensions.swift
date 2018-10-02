//
//  MainPresenterGoogleExtensions.swift
//  WeatherApp
//
//  Created by Alessio Roberto on 01/10/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Foundation
import GooglePlaces

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
