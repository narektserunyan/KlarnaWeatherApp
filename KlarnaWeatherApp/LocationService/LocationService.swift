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
    private(set) var location = PassthroughSubject<CLLocation?, Never>()
    private(set) var locationError = PassthroughSubject<LocationError?, Never>()
    
    private let locationManager = CLLocationManager()
    private let api: LocationApi
    
    init(api: LocationApi = RealLocationService()) {
        self.api = api
        super.init()
        locationManager.delegate = self
    }
    
    func fetchLocation() {
        if locationManager.authorizationStatus == .authorizedAlways ||
            locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.requestLocation()
        } else {
            if locationManager.authorizationStatus != .notDetermined {
                locationError.send(.unauthorized)
            }
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func retrievePlacemarks(location: CLLocation?) -> AnyPublisher<String?, Error> {
        return api.retrievePlacemarks(location: location)
    }
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            locationError.send(.unauthorized)
        } else {
            locationError.send(.unableToDetermineLocation)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location.send(locations.last)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways,
             .authorizedWhenInUse:
            locationError.send(.none)
            manager.requestLocation()
        case .denied,
             .restricted:
            locationError.send(.unauthorized)
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
}
