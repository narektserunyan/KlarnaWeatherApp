//
//  FakeLocationService.swift
//  KlarnaWeatherAppTests
//
//  Created by Narek Tserunyan on 03.09.23.
//

import Foundation
import Combine
import CoreLocation
@testable import KlarnaWeatherApp

final class FakeLocationService: LocationApi {
    var shouldReturnError = false
    func retrievePlacemarks(location: CLLocation?) -> AnyPublisher<String?, Error> {
        if shouldReturnError {
            return Fail(error: LocationError.fetchError).eraseToAnyPublisher()
        }
        return Result.Publisher("Antarctica")
                    .mapError { $0 as Error }
                    .delay(for: .seconds(1), scheduler: DispatchQueue.global())
                    .eraseToAnyPublisher()
    }
}
