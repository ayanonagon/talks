//
//  XCTestCaseExtension.swift
//  Weather
//
//  Created by Ayaka Nonaka on 7/4/16.
//  Copyright © 2016 Ayaka Nonaka. All rights reserved.
//

import XCTest
import Foundation
@testable import Weather

extension XCTestCase {

    func loadJSONFixture(for fileName: String) -> JSONDictionary {
        let path = NSBundle(forClass: self.dynamicType).pathForResource(fileName, ofType: "json")
        let data = NSData(contentsOfFile: path!)!
        let json = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
        return json as! JSONDictionary
    }
}
