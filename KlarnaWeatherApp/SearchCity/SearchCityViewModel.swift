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
    private(set) var error = PassthroughSubject<Error?, Never>()
    private var cancellables: Set<AnyCancellable> = []
    
    let onQueryChange = PassthroughSubject<String, Never>()
    let defaultCity = PassthroughSubject<Location?, Never>()

    private let api: Networking
    init(api: Networking = WebApi()) {
        self.api = api
        
        onQueryChange
            .sink { [weak self] query in
                self?.fetchLocations(by: query)
            }
            .store(in: &cancellables)
    }
    
    private func fetchLocations(by query: String) {
        if query.isEmpty {
            locations.send([])
            return
        }
        
        api.fetchLocations(by: query)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {[weak self] completion in
                if case .failure(let error) = completion {
                    self?.error.send(error)
                }
            }, receiveValue: {[weak self] value in
                self?.locations.send(value)
            })
            .store(in: &cancellables)
    }
}
