//
//  ObservationTests.swift
//  Weather
//
//  Created by Ayaka Nonaka on 7/4/16.
//  Copyright © 2016 Ayaka Nonaka. All rights reserved.
//

import XCTest
@testable import Weather

class ObservationTests: XCTestCase {

    func testInitialization() {
        let json = loadJSONFixture(for: "observation")
        let observation = Observation(dictionary: json)

        XCTAssertEqual("San Francisco, CA", observation!.displayLocation.fullCityName)
        XCTAssertEqual("North Mission (Valencia and Market), San Francisco, California", observation!.observationLocation.fullCityName)
        XCTAssertEqual("Partly Cloudy", observation!.weather)

        // TODO: File radar about XCTAssertEqualWithAccuracy supporting optionals.
        XCTAssertEqualWithAccuracy(56.1, observation!.temperatureFahrenheit, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(13.4, observation!.temperatureCelcius, accuracy: 0.001)
    }
}
