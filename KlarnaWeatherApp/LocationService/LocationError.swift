//
//  LocationError.swift
//  KlarnaWeatherApp
//
//  Created by Narek Tserunyan on 02.09.23.
//

import Foundation

enum LocationError: Error {
    case unauthorized
    case unableToDetermineLocation
    case fetchError
}
