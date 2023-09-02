//
//  SearchCityViewModel.swift
//  KlarnaWeatherApp
//
//  Created by Narek Tserunyan on 02.09.23.
//

import Foundation
import Combine

final class SearchCityViewModel {
    
    @Published private(set) var locations: [Location]?
    private let api: Networking
    
    init(api: Networking = WebApi()) {
        self.api = api
    }
    
    func fetchLocations(by query: String) -> AnyPublisher<Void, APIError> {
        return api.fetchLocations(by: query)
            .mapError { error in
                return APIError.requestFailed(error)
            }
            .handleEvents(receiveOutput: { [weak self] locations in
                self?.locations = locations
            })
            .map { _ in return () }
            .eraseToAnyPublisher()
    }
}
