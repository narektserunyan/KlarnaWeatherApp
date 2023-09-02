//
//  CurrentWeatherViewModel.swift
//  KlarnaWeatherApp
//
//  Created by Narek Tserunyan on 02.09.23.
//

import Foundation
import Combine

final class CurrentWeatherViewModel {
    @Published private(set) var weather: Weather?
    
    private let api: Networking
    
    init(api: Networking = WebApi()) {
        self.api = api
    }
    
    private func fetchWeather(lat: Double, lon: Double) -> AnyPublisher<Void, Error> {
        return api.fetchWeather(lat: lat, lon: lon)
            .mapError { error in
                return APIError.requestFailed(error)
            }
            .handleEvents(receiveOutput: { [weak self] weatherApiResponse in
                self?.weather = weatherApiResponse.main
                self?.weather?.weatherCondition = weatherApiResponse.weatherCondition.first
            })
            .map { _ in return () }
            .eraseToAnyPublisher()
    }
}
