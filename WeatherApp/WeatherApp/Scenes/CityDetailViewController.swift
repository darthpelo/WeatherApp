//
//  CityDetailViewController.swift
//  WeatherApp
//
//  Created by Alessio Roberto on 30/09/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import GooglePlaces
import UIKit

class CityDetailViewController: UIViewController {
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var city: (name: String, placeID: String)?
    lazy var presenter: CityDetailPresentable = CityDetailPresenter(view: self)
    private var dataSource: TableViewDataSource<DayForecastLight>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = city?.name
        
        dayForecastDidLoad([])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let city = city else { return }
        
        loadFirstPhotoForPlace(placeID: city.placeID)
        presenter.setupUI(withCity: city.name)
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
    
    func loadFirstPhotoForPlace(placeID: String) {
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                if let firstPhoto = photos?.results.first {
                    self.loadImageForMetadata(photoMetadata: firstPhoto)
                }
            }
        }
    }
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: { [weak self]
            (photo, error) -> Void in
            guard let self = self else { return }
            
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                self.backgroundImage.image = photo
//                self.attributionTextView.attributedText = photoMetadata.attributions;
            }
        })
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
