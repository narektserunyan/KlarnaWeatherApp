//
//  CurrentWeatherViewController.swift
//  KlarnaWeatherApp
//
//  Created by Narek Tserunyan on 02.09.23.
//

import UIKit
import Combine
import CoreLocation

final class CurrentWeatherViewController: Controller<CurrentWeatherViewModel> {
    
    private var currentWeatherView: CurrentWeatherView?
    private var cancellables: Set<AnyCancellable> = []
    
    override func loadView() {
        super.loadView()
        currentWeatherView = CurrentWeatherView(frame: view.bounds)
        view = currentWeatherView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBindings()
        
        updateWithCurrentLocation()
        
        let currentLocationButton = UIBarButtonItem(image: UIImage(systemName: "location.square"), style: .done, target: self, action: #selector(updateWithCurrentLocation))
        navigationItem.leftBarButtonItems = [currentLocationButton]
        
        let searchCityButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchCity))
        navigationItem.rightBarButtonItems = [searchCityButton]
    }
    
    private func setBindings() {
        viewModel.locationError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] locationErr in
                if locationErr != nil {
                    self?.currentWeatherView?.shouldAnimateIndicator(start: false)
                }
                self?.currentWeatherView?.shoudlShowError(show: locationErr != nil)
            }
            .store(in: &cancellables)
        
        viewModel.connectionError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.showAlert()
            }
            .store(in: &cancellables)
        
        
        viewModel.$weather
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _weather in
                guard let _weather = _weather else { return }
                self?.currentWeatherView?.shouldAnimateIndicator(start: false)
                self?.currentWeatherView?.updateUI(with: _weather)
                
            }
            .store(in: &cancellables)
    }
    
    @objc private func searchCity() {
        let searchCityViewController = SearchCityViewController(viewModel: SearchCityViewModel())
        searchCityViewController.defaultCity
            .receive(on: DispatchQueue.main)
            .sink { [weak self] city in
                guard let city = city else { return }
                self?.viewModel.fetchWeatherWithCityName(for: CLLocation(latitude: city.lat, longitude: city.lon))
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
        
        navigationController?.pushViewController(searchCityViewController, animated: true)
    }
    
    @objc private func updateWithCurrentLocation() {
        currentWeatherView?.shouldAnimateIndicator(start: true)
        viewModel.fetchCurrentLocation()
    }
    
    private func showAlert() {
        if presentedViewController != nil { return }
        let alert = ErrorAlertBuilder().title("Network problem").message("Check your internet connection").build()
        present(alert, animated: true, completion: nil)
    }
}
