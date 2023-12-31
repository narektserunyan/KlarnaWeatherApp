//
//  CurrentWeatherViewModel.swift
//  KlarnaWeatherApp
//
//  Created by Narek Tserunyan on 02.09.23.
//

import Foundation
import Combine
import CoreLocation

final class CurrentWeatherViewModel {
    
    @Published private(set) var weather: Weather?
    private(set) var locationError = PassthroughSubject<LocationError?, Never>()
    private(set) var connectionError = PassthroughSubject<URLError?, Never>()
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let locationService: LocationService
    private let api: Networking
    init(api: Networking = WebApi(), locationServiceApi: LocationApi = RealLocationService()) {
        self.api = api
        self.locationService = LocationService(api: locationServiceApi)
        
        locationService.locationError.subscribe(locationError).store(in: &cancellables)
        
        locationService.location
            .sink { [weak self] location in
                guard let location = location else { return }
                self?.fetchWeatherWithCityName(for: location)
            }
            .store(in: &cancellables)
    }
    
    func fetchCurrentLocation() {
        locationService.fetchLocation()
    }
    
    func fetchWeatherWithCityName(for location: CLLocation) {
        let fetchCityName = locationService.retrievePlacemarks(location: location)
        let fetchWeather = fetchWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        
        Publishers.Zip(fetchCityName, fetchWeather)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {[weak self] completion in
                if case .failure(let error) = completion {
                    self?.connectionError.send(error as? URLError)
                }
            }, receiveValue: {[weak self] cityName, _ in
                self?.weather?.cityName = cityName
                self?.connectionError.send(nil)
            })
            .store(in: &cancellables)
    }
    
    private func fetchWeather(lat: Double, lon: Double) -> AnyPublisher<WeatherApiResponse, Error> {
        return api.fetchWeather(lat: lat, lon: lon)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] weatherApiResponse in
                var weather = weatherApiResponse.main
                weather.weatherCondition = weatherApiResponse.weatherCondition.first
                self?.weather = weather
            })
            .eraseToAnyPublisher()
    }
}
