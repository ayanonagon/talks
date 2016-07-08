//
//  CAGradientLayerExtension.swift
//  Weather
//
//  Created by Ayaka Nonaka on 7/4/16.
//  Copyright © 2016 Ayaka Nonaka. All rights reserved.
//

import Foundation
import UIKit

public extension CAGradientLayer {

    static func gradientLayer(with gradient: Gradient) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [gradient.startColor.CGColor, gradient.endColor.CGColor]
        gradientLayer.startPoint = CGPointMake(0.5, 0);
        gradientLayer.endPoint = CGPointMake(0.5, 1);
        gradientLayer.locations = [0.4, 1];
        return gradientLayer
    }
}
