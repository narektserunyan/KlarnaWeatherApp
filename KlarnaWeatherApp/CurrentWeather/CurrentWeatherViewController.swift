//
//  CurrentWeatherViewController.swift
//  KlarnaWeatherApp
//
//  Created by Narek Tserunyan on 02.09.23.
//

import UIKit
import Combine
import CoreLocation

final class CurrentWeatherViewController: Controller<CurrentWeatherViewModel, CurrentWeatherView> {
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func loadView() {
        super.loadView()
        contentView = CurrentWeatherView(frame: view.bounds)
        view = contentView
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
                self?.contentView?.shoudlShowError(show: locationErr != nil, message: "Current location couln't be determined, enable from system settings")
                self?.contentView?.shouldAnimateIndicator(start: false)
            }
            .store(in: &cancellables)
        
        viewModel.connectionError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.contentView?.shoudlShowError(show: error != nil, message: "Internet connection issue")
                self?.contentView?.shouldAnimateIndicator(start: false)
            }
            .store(in: &cancellables)
        
        
        viewModel.$weather
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _weather in
                guard let _weather = _weather else { return }
                self?.contentView?.shouldAnimateIndicator(start: false)
                self?.contentView?.updateUI(with: _weather)
                
            }
            .store(in: &cancellables)
    }
    
    @objc private func searchCity() {
        let searchViewModel = SearchCityViewModel()
        searchViewModel.defaultCity
            .receive(on: DispatchQueue.main)
            .sink { [weak self] city in
                guard let city = city else { return }
                self?.viewModel.fetchWeatherWithCityName(for: CLLocation(latitude: city.lat, longitude: city.lon))
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
        
        let searchCityViewController = SearchCityViewController(viewModel: searchViewModel)
        navigationController?.pushViewController(searchCityViewController, animated: true)
    }
    
    @objc private func updateWithCurrentLocation() {
        contentView?.shoudlShowError(show: false)
        contentView?.shouldAnimateIndicator(start: true)
        viewModel.fetchCurrentLocation()
    }
}
