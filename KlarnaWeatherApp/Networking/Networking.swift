//
//  Networking.swift
//  KlarnaWeatherApp
//
//  Created by Narek Tserunyan on 02.09.23.
//

import Foundation
import Combine

protocol Networking {
    func fetchLocations(by query: String) -> AnyPublisher<[Location], Error>
    func fetchWeather(lat: Double, lon: Double) -> AnyPublisher<WeatherApiResponse, Error>
}

final class WebApi: Networking {
    
    func fetchLocations(by query: String) -> AnyPublisher<[Location], Error> {
        let path = "/geo/1.0/direct"
        let queryItems = [URLQueryItem(name: "q", value: query),
                          URLQueryItem(name: "limit", value: "3")]
        return Request<[Location]>(queryItems: queryItems, path: path).execute()
        
    }
    
    func fetchWeather(lat: Double, lon: Double) -> AnyPublisher<WeatherApiResponse, Error> {
        let path = "/data/2.5/weather"
        let queryItems = [URLQueryItem(name: "lat", value: "\(lat)"),
                          URLQueryItem(name: "lon", value: "\(lon)")]
        return Request<WeatherApiResponse>(queryItems: queryItems, path: path).execute()
    }
}
