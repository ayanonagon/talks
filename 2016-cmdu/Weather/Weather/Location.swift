//
//  Location.swift
//  Weather
//
//  Created by Ayaka Nonaka on 7/3/16.
//  Copyright © 2016 Ayaka Nonaka. All rights reserved.
//

import Foundation

struct Location: Equatable {
    let fullCityName: String
    let city: String
    let state: String
    let country: String
    let countryISO3166: String
    let latitude: String
    let longitude: String
    let zipCode: String?
    let elevation: String
}

func ==(lhs: Location, rhs: Location) -> Bool {
    return lhs.fullCityName == rhs.fullCityName &&
    lhs.city == rhs.city &&
    lhs.state == rhs.state &&
    lhs.country == rhs.country &&
    lhs.countryISO3166 == rhs.countryISO3166 &&
    lhs.latitude == rhs.latitude &&
    lhs.longitude == rhs.longitude &&
    lhs.zipCode == rhs.zipCode &&
    lhs.elevation == rhs.elevation
}

extension Location: JSONDeserializable {
    
    init?(dictionary: JSONDictionary) {
        guard
            let fullCityName = dictionary["full"] as? String,
            let city = dictionary["city"] as? String,
            let state = dictionary["state"] as? String,
            let country = dictionary["country"] as? String,
            let countryISO3166 = dictionary["country_iso3166"] as? String,
            let latitude = dictionary["latitude"] as? String,
            let longitude = dictionary["longitude"] as? String,
            let elevation = dictionary["elevation"] as? String
        else { return nil }
        
        self.fullCityName = fullCityName
        self.city = city
        self.state = state
        self.country = country
        self.countryISO3166 = countryISO3166
        self.latitude = latitude
        self.longitude = longitude
        self.zipCode = dictionary["zip"] as? String
        self.elevation = elevation
    }
}
