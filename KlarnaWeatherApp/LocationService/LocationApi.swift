//
//  LocationApi.swift
//  KlarnaWeatherApp
//
//  Created by Narek Tserunyan on 03.09.23.
//

import Foundation
import CoreLocation
import Combine

protocol LocationApi {
    func retrievePlacemarks(loc: CLLocation?) -> AnyPublisher<String?, Error>
}

class RealLocationService: LocationApi {
    private let geocoder = CLGeocoder()
    func retrievePlacemarks(loc: CLLocation?) -> AnyPublisher<String?, Error> {
        guard let location = loc else { return Fail(error: LocationError.fetchError).eraseToAnyPublisher() }
        return geocoder.reverseGeocodeLocationPublisher(location)
            .map { value -> String? in
                print(value)
                return value.locality
            }.eraseToAnyPublisher()
    }
}

extension CLGeocoder {
    func reverseGeocodeLocationPublisher(_ location: CLLocation, preferredLocale locale: Locale? = nil) -> AnyPublisher<CLPlacemark, Error> {
        Future<CLPlacemark, Error> { promise in
            self.reverseGeocodeLocation(location, preferredLocale: locale) { placemarks, error in
                guard let placemark = placemarks?.first else {
                    return promise(.failure(error ?? CLError(.geocodeFoundNoResult)))
                }
                return promise(.success(placemark))
            }
        }.eraseToAnyPublisher()
    }
}
