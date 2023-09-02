//
//  SearchCityViewModel.swift
//  KlarnaWeatherApp
//
//  Created by Narek Tserunyan on 02.09.23.
//

import Foundation

final class SearchCityViewModel {
    
    private let api: Networking
    
    init(api: Networking = WebApi()) {
        self.api = api
    }
}
