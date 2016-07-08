//
//  AppDelegate.swift
//  Weather
//
//  Created by Ayaka Nonaka on 7/3/16.
//  Copyright © 2016 Ayaka Nonaka. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        // Because live-demo. :P
        let json = loadJSONFixture(for: "observation")
        let observation = Observation(dictionary: json)!

        let viewController = WeatherViewController(with: observation)

        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        self.window = window

        return true
    }

    private func loadJSONFixture(for fileName: String) -> JSONDictionary {
        let path = NSBundle(forClass: self.dynamicType).pathForResource(fileName, ofType: "json")
        let data = NSData(contentsOfFile: path!)!
        let json = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
        return json as! JSONDictionary
    }
}
