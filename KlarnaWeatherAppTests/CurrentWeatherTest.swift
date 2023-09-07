//
//  CurrentWeatherTest.swift
//  KlarnaWeatherAppTests
//
//  Created by Narek Tserunyan on 07.09.23.
//

import XCTest
import Combine
import CoreLocation
@testable import KlarnaWeatherApp

final class CurrentWeatherTest: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    func testFetchWeather_Success() {
        let expectation = XCTestExpectation(description: "Fetch weather Success")
        let viewModel = CurrentWeatherViewModel(api: FakeAPIService(), locationServiceApi: FakeLocationService())

        viewModel.$weather
            .receive(on: DispatchQueue.main)
            .compactMap{$0}
            .sink { _weather in
                XCTAssertNotNil(_weather)
                XCTAssertEqual(_weather?.temperature, -300)
                XCTAssertEqual(_weather?.feelsLikeTemperature, -305)
                XCTAssertEqual(_weather?.weatherCondition?.weatherDescription, "Warm")
                expectation.fulfill()
                
            }
            .store(in: &cancellables)
        
        viewModel.connectionError
            .receive(on: DispatchQueue.main)
            .sink { _ in
                XCTFail("Expected Success")
            }
            .store(in: &cancellables)

        viewModel.fetchWeatherWithCityName(for: CLLocation(latitude: 100, longitude: 100))
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testFetchWeather_Failure() {
        let expectation = XCTestExpectation(description: "Fetch weather Failure")
        
        let api = FakeAPIService()
        api.shouldReturnError = true
        
        let locationApi = FakeLocationService()
        locationApi.shouldReturnError = true
        
        let viewModel = CurrentWeatherViewModel(api: api, locationServiceApi: locationApi)

        viewModel.$weather
            .receive(on: DispatchQueue.main)
            .compactMap{$0}
            .sink { _weather in
                XCTFail("Expected Error")
            }
            .store(in: &cancellables)

        viewModel.connectionError
            .receive(on: DispatchQueue.main)
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchWeatherWithCityName(for: CLLocation(latitude: 100, longitude: 100))

        wait(for: [expectation], timeout: 2.0)
    }
    
    func testFetchWeather_Failure_When_WeatherIsResponding() {
        let expectation = XCTestExpectation(description: "Fetch weather Failure")
                
        let locationApi = FakeLocationService()
        locationApi.shouldReturnError = true
        
        let viewModel = CurrentWeatherViewModel(api: FakeAPIService(), locationServiceApi: locationApi)

        viewModel.$weather
            .receive(on: DispatchQueue.main)
            .compactMap{$0}
            .sink { _weather in
                XCTFail("Expected Error")
            }
            .store(in: &cancellables)

        viewModel.connectionError
            .receive(on: DispatchQueue.main)
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchWeatherWithCityName(for: CLLocation(latitude: 100, longitude: 100))

        wait(for: [expectation], timeout: 2.0)
    }

}
