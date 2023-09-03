//
//  KlarnaWeatherAppTests.swift
//  KlarnaWeatherAppTests
//
//  Created by Narek Tserunyan on 02.09.23.
//

import XCTest
import Combine
import CoreLocation
@testable import KlarnaWeatherApp

final class KlarnaWeatherAppTests: XCTestCase {

    private var cancellables = Set<AnyCancellable>()
    
    func testFetchLocations_Success() {
        let expectation = XCTestExpectation(description: "Fetch locations Success")
        let viewModel = SearchCityViewModel(api: FakeAPIService())

        viewModel.locations
            .receive(on: DispatchQueue.main)
            .compactMap{$0}
            .sink { locations in
                XCTAssertEqual(locations.count, 2)
                XCTAssertEqual(locations.first?.name, "Iceberg")
                XCTAssertEqual(viewModel.locations.value?.count, 2)
                XCTAssertEqual(viewModel.locations.value?.first?.name, "Iceberg")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchLocations(by: "query")
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected Success")
                }
            }, receiveValue: { locations in
                XCTAssertEqual(viewModel.locations.value?.count, 2)
                XCTAssertEqual(viewModel.locations.value?.first?.name, "Iceberg")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testFetchLocations_Failure() {
        let expectation = XCTestExpectation(description: "Fetch locations Failure")
        let api = FakeAPIService()
        api.shouldReturnError = true
        let viewModel = SearchCityViewModel(api: api)
        
        viewModel.locations
            .receive(on: DispatchQueue.main)
            .compactMap{$0}
            .sink { locations in
                XCTFail("Expected to not enter")
            }
            .store(in: &cancellables)
        
        viewModel.fetchLocations(by: "query")
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    expectation.fulfill()
                }
            }, receiveValue: { tasks in
                XCTFail("Expected an error")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
        
    }
    
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
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    

}
