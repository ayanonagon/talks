//
//  Observation.swift
//  Weather
//
//  Created by Ayaka Nonaka on 7/3/16.
//  Copyright © 2016 Ayaka Nonaka. All rights reserved.
//

import Foundation

struct Observation: Equatable {
    let displayLocation: Location
    let observationLocation: Location
    let weather: String
    let temperatureCelcius: Double
    let temperatureFahrenheit: Double
}

func ==(lhs: Observation, rhs: Observation) -> Bool {
    return lhs.displayLocation == rhs.displayLocation &&
    lhs.observationLocation == rhs.observationLocation &&
    lhs.weather == rhs.weather &&
    lhs.temperatureCelcius == rhs.temperatureCelcius &&
    lhs.temperatureFahrenheit == rhs.temperatureFahrenheit
}

extension Observation: JSONDeserializable {
    
    init?(dictionary: JSONDictionary) {
        guard
            let locationDictionary = dictionary["display_location"] as? JSONDictionary,
            let displayLocation = Location(dictionary: locationDictionary),
            let observationDictionary = dictionary["observation_location"] as? JSONDictionary,
            let observationLocation = Location(dictionary: observationDictionary),
            let weather = dictionary["weather"] as? String,
            let temperatureCelcius = dictionary["temp_c"] as? Double,
            let temperatureFahrenheit = dictionary["temp_f"] as? Double
        else { return nil }
        self.displayLocation = displayLocation
        self.observationLocation = observationLocation
        self.weather = weather
        self.temperatureCelcius = temperatureCelcius
        self.temperatureFahrenheit = temperatureFahrenheit
    }
}

extension Observation: WeatherViewControllerDisplayable {
    var location: String {
        return displayLocation.fullCityName
    }
}
