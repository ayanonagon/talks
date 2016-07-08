//
//  LocationTests.swift
//  WeatherTests
//
//  Created by Ayaka Nonaka on 7/3/16.
//  Copyright © 2016 Ayaka Nonaka. All rights reserved.
//

import XCTest
@testable import Weather

class LocationTests: XCTestCase {

    func testInitialization() {
        let json = loadJSONFixture(for: "location")
        let location = Location(dictionary: json)

        XCTAssertEqual("San Francisco, CA", location?.fullCityName)
        XCTAssertEqual("San Francisco", location?.city)
        XCTAssertEqual("CA", location?.state)
        XCTAssertEqual("US", location?.country)
        XCTAssertEqual("US", location?.countryISO3166)
        XCTAssertEqual("37.77500916", location?.latitude)
        XCTAssertEqual("-122.41825867", location?.longitude)
        XCTAssertEqual("94101", location?.zipCode)
        XCTAssertEqual("47.00000000", location?.elevation)
    }
}
