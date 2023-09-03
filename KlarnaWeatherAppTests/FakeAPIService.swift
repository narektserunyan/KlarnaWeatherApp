//
//  FakeAPIService.swift
//  KlarnaWeatherAppTests
//
//  Created by Narek Tserunyan on 03.09.23.
//

import Foundation
import Combine
@testable import KlarnaWeatherApp

class FakeAPIService: Networking {
    var shouldReturnError = false
    
    func fetchLocations(by query: String) -> AnyPublisher<[Location], Error> {
        if shouldReturnError {
            let error = NSError(domain: "MockAPIService", code: 1, userInfo: nil)
            return Fail(error: error)
                .delay(for: .seconds(1), scheduler: DispatchQueue.global()) // Introduce a 1-second delay
                .eraseToAnyPublisher()
        }
        let dummyLocations: [Location] = [
            Location(name: "Iceberg", lat: 90, lon: 0, country: "Antarctica"),
            Location(name: "Another iceberg", lat: 90, lon: 1, country: "Antarctica")
        ]
        return Result.Publisher(dummyLocations)
                    .mapError { $0 as Error }
                    .delay(for: .seconds(1), scheduler: DispatchQueue.global())
                    .eraseToAnyPublisher()
    }
    
    func fetchWeather(lat: Double, lon: Double) -> AnyPublisher<WeatherApiResponse, Error> {
        if shouldReturnError {
            let error = NSError(domain: "MockAPIService", code: 1, userInfo: nil)
            return Fail(error: error)
                .delay(for: .seconds(1), scheduler: DispatchQueue.global()) // Introduce a 1-second delay
                .eraseToAnyPublisher()
        }
        let dummyWeather: Weather = Weather(temperature: -300, feelsLikeTemperature: -305)
        let weatherConditions: [WeatherCondition] = [WeatherCondition(weatherDescription: "Warm")]
        let dummyWeatherApiResponse: WeatherApiResponse = WeatherApiResponse(main: dummyWeather, weatherCondition: weatherConditions)
        
        return Result.Publisher(dummyWeatherApiResponse)
                    .mapError { $0 as Error }
                    .delay(for: .seconds(1), scheduler: DispatchQueue.global())
                    .eraseToAnyPublisher()
    }
}
