//
//  CityDetailPresenter.swift
//  WeatherApp
//
//  Created by Alessio Roberto on 30/09/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import GooglePlaces
import Moya
import Unbox

protocol CityDetailPresentable: class {
    func setupUI(withCity city: String)
    func loadFirstPhotoForPlace(placeID: String)
}

protocol CityDetailView: class {
    func updateTopView(with weather: CityWeatherDetail)
    func updateForecast(with forecast: [DayForecastLight])
    func updateBackgroundImage(with image: UIImage?)
}

final class CityDetailPresenter: NSObject, CityDetailPresentable {
    weak private var view: CityDetailView?
    private var provider: MoyaProvider<OpenWeather>
    
    init(view: CityDetailView, provider: MoyaProvider<OpenWeather> = openWeather) {
        self.view = view
        self.provider = provider
    }
    
    func setupUI(withCity city: String) {
        provider.request(.forecast(city: city)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(moyaResponse):
                self.prepareData(moyaResponse)
            case let .failure(error):
                print("Error: ", error.localizedDescription)
            }
        }
    }
    
    func loadFirstPhotoForPlace(placeID: String) {
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { photos, error -> Void in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                if let firstPhoto = photos?.results.first {
                    self.loadImageForMetadata(photoMetadata: firstPhoto)
                }
            }
        }
    }
    
    // MARK: - Private
    private func prepareData(_ moyaResponse: Response) {
        do {
            let data = try moyaResponse.mapJSON()
            if let dictionary = data as? [String: Any] {
                let item: CityForecast? = try unbox(dictionary: dictionary)
                updateTopView(with: item?.days.first?.main)
                updateForecast(with: item?.days)
            }
        } catch let error {
            print(error)
        }
    }
    private func updateTopView(with item: Main?) {
        guard let item = item else { return }
        
        let weatherDetail = CityWeatherDetail(main: item)
        
        view?.updateTopView(with: weatherDetail)
    }
    
    private func updateForecast(with forecasts: [Forecast]?) {
        guard let forecasts = forecasts else { return }
        
        var dataSource: [DayForecastLight] = []
        for forecast in forecasts {
            let light = DayForecastLight(forecast)
            dataSource.append(light)
        }
        view?.updateForecast(with: dataSource)
    }
    
    private  func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: { [weak self]
            photo, error -> Void in
            guard let self = self else { return }
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                self.view?.updateBackgroundImage(with: photo)
            }
        })
    }
}
