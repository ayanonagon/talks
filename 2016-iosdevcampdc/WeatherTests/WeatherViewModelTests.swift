//
//  WeatherViewModelTests.swift
//  Weather
//
//  Created by Ayaka Nonaka on 7/6/16.
//  Copyright © 2016 Ayaka Nonaka. All rights reserved.
//

import XCTest
@testable import Weather

class WeatherViewModelTests: XCTestCase {

    func testInitialization() {
        let json = loadJSONFixture(for: "observation")
        let observation = Observation(dictionary: json)!
        let viewModel = WeatherViewModel(with: observation)

        XCTAssertEqual("San Francisco, CA", viewModel.city)
        XCTAssertEqual("Partly Cloudy", viewModel.weather)
        XCTAssertEqual("13°", viewModel.temperature)
    }
}
