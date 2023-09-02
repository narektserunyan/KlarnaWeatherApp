//
//  Weather.swift
//  KlarnaWeatherApp
//
//  Created by Narek Tserunyan on 02.09.23.
//

import Foundation

struct WeatherApiResponse: Decodable {
    let main: Weather
    let weatherCondition: [WeatherCondition]
    
    enum CodingKeys: String, CodingKey {
        case main
        case weatherCondition = "weather"
    }
}

struct WeatherCondition: Decodable {
    let weatherDescription: String
    
    enum CodingKeys: String, CodingKey {
        case weatherDescription = "description"
    }
}

struct Weather: Decodable {
    let temperature: Double
    let feelsLikeTemperature: Double
    
    var weatherCondition: WeatherCondition?
    var cityName: String?
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case feelsLikeTemperature = "feels_like"
    }
}
