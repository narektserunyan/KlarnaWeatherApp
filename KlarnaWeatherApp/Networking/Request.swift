//
//  Request.swift
//  KlarnaWeatherApp
//
//  Created by Narek Tserunyan on 02.09.23.
//

import Foundation
import Combine

final class Request<T: Decodable> {
    private let baseURL = "https://api.openweathermap.org"
    private var queryItems: [URLQueryItem]?
    private var path: String
    private var isUsingApiKey: Bool
    
    init(queryItems: [URLQueryItem]? = nil, path: String, isUsingApiKey: Bool = true) {
        self.queryItems = queryItems
        self.path = path
        self.isUsingApiKey = isUsingApiKey
    }
    
    func execute() -> AnyPublisher<T, Error> {
        
        guard var components = URLComponents(string: baseURL + path) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        components.queryItems = queryItems
        
        if isUsingApiKey {
            guard let apiKey = PlistExtractor.getAPIKey() else {
                return Fail(error: APIError.fetching as Error).eraseToAnyPublisher()
            }
            let apiKeyQuery = URLQueryItem(name: "appid", value: apiKey)
            components.queryItems?.append(apiKeyQuery)
        }
        
        guard let url = components.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
