//
//  DictionaryDeserializable.swift
//  Weather
//
//  Created by Ayaka Nonaka on 7/3/16.
//  Copyright © 2016 Ayaka Nonaka. All rights reserved.
//

import Foundation

typealias JSONDictionary = Dictionary<String, AnyObject>

protocol JSONDeserializable {
    init?(dictionary: JSONDictionary)
}
