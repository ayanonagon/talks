//
//  WeatherViewControllerTests.swift
//  Weather
//
//  Created by Ayaka Nonaka on 7/5/16.
//  Copyright © 2016 Ayaka Nonaka. All rights reserved.
//

import XCTest
@testable import Weather

class WeatherViewControllerTests: XCTestCase {

    func testInitialization() {
        let json = loadJSONFixture(for: "observation")
        let observation = Observation(dictionary: json)!
        let viewModel = WeatherViewModel(with: observation)

        let viewController = WeatherViewController(with: viewModel)

        XCTAssertEqual(viewModel, viewController.viewModel)

        // Test viewController.weatherLabel?
        // Test viewController.temperatureLabel?
        // Test viewController.cityLabel?

        // => Now handled by view model. 🎉





        // Problems before:

        // 1. weatherLabel, temperatureLabel, cityLabel are private (by design!)
        // => Not a problem anymore!





        // 2. We *could* do UI testing instead, but unit tests are way faster.
        // => We can continue to rely on unit tests.





        // 3. WeatherViewController is coupled to Observation,
        // which is very specific to Weather Underground’s API.
        // => WeatherViewController is initialized with the view model now.





        // We can do better!
        // => We did!

        // But is this good enough? 🤔

















        
        // No. Ya tú sabes. 🙃






        // More problems:

        // 1. Pretty annoying to test WeatherViewController.
        //    1. Load JSON.
        //    2. Create Observation.
        //    3. Create WeatherViewModel with Observation.
        //    4. Initialize WeatherViewController with view model.





        // 2. We didn’t *really* decouple WeatherViewController
        //    and Observation. We just added a layer of indirection.





        // 3. Now Observation and WeatherViewModel are tightly coupled.
        //    Makes more sense for WeatherViewModel and WeatherViewController
        //    to be more closely related.
    }
}
