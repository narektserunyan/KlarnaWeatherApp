//
//  LocationService.swift
//  KlarnaWeatherApp
//
//  Created by Narek Tserunyan on 02.09.23.
//

import Foundation
import CoreLocation
import Combine

final class LocationService: NSObject {
    @Published private(set) var location: CLLocation?
    @Published private(set) var locationError: LocationError?
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func fetchLocation() {
        if locationManager.authorizationStatus == .authorizedAlways ||
            locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.requestLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func retrievePlacemarks(loc: CLLocation?) -> AnyPublisher<String?, Error> {
        guard let location = loc else { return Fail(error: LocationError.fetchError).eraseToAnyPublisher() }
        return geocoder.reverseGeocodeLocationPublisher(location)
            .map { value -> String? in
                return value.locality
            }.eraseToAnyPublisher()
    }
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            locationError = .unauthorized
        } else {
            locationError = .unableToDetermineLocation
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways,
                .authorizedWhenInUse:
            locationError = .none
            manager.requestLocation()
        case .denied,
                .notDetermined,
                .restricted:
            locationError = .unauthorized
        @unknown default:
            locationError = .unauthorized
        }
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
