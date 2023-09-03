//
//  SearchCityViewModel.swift
//  KlarnaWeatherApp
//
//  Created by Narek Tserunyan on 02.09.23.
//

import Foundation
import Combine

final class SearchCityViewModel {
    
    private(set) var locations = CurrentValueSubject<[Location]?, Never>(nil)
    
    private let api: Networking
    init(api: Networking = WebApi()) {
        self.api = api
    }
    
    func fetchLocations(by query: String) -> AnyPublisher<[Location], Error> {
        return api.fetchLocations(by: query)
            .handleEvents(receiveOutput: { [weak self] locations in
                self?.locations.send(locations)
            })
            .eraseToAnyPublisher()
    }
}
