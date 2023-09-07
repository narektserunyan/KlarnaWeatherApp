//
//  FetchLocationsTest.swift
//  KlarnaWeatherAppTests
//
//  Created by Narek Tserunyan on 07.09.23.
//

import XCTest
import Combine
@testable import KlarnaWeatherApp

final class FetchLocationsTest: XCTestCase {

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
        
        viewModel.error
            .receive(on: DispatchQueue.main)
            .sink { _ in
                XCTFail("Expected Success")
            }
            .store(in: &cancellables)
        
        viewModel.fetchLocations(by: "testQuery")
        
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
        
        viewModel.error
            .receive(on: DispatchQueue.main)
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchLocations(by: "Testquery")
        
        wait(for: [expectation], timeout: 2.0)
    }
}
