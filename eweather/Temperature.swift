//
//  Temperature.swift
//  eweather
//
//  Created by Thomas Kooi on 2/12/17.
//  Copyright © 2017 Thomas Kooi. All rights reserved.
//

import Foundation
import UIKit

struct Temperature: Equatable {
    enum TemperatureUnit {
        case kelvin, celcius, fahrenheit
    }
    
    let value: Double
    let unit: TemperatureUnit
    
    init(_ value: Double, unit: TemperatureUnit = .kelvin) {
        self.value = value
        self.unit = unit
    }
    
    func format() -> String {
        return "\(Int(value.rounded()))°"
    }
    
    func celcius() -> Temperature {
        switch unit {
            case .kelvin: return Temperature(value - 273.15, unit: .celcius)
            case .fahrenheit: return Temperature((value - 32) * 5 / 9, unit: .celcius)
            case .celcius: return self
        }
    }
    
    func fahrenheit() -> Temperature {
        switch unit {
            case .kelvin: return Temperature(value * 9 / 5 - 459.67, unit: .fahrenheit)
            case .fahrenheit: return self
            case .celcius: return Temperature(value * 9 / 5 + 32, unit: .fahrenheit)
        }
    }
    
    // MARK: Equatable
    
    static func ==(lhs: Temperature, rhs: Temperature) -> Bool {
        return lhs.value == rhs.value && lhs.unit == rhs.unit
    }
}

extension Temperature {
    func color() -> UIColor {
        let fahrenheitTemperature = self.fahrenheit()
        
        switch Int(fahrenheitTemperature.value) {
        case Int.min..<32: return UIColor.Temperatures.cold
        case 32..<50: return UIColor.Temperatures.chilly
        case 50..<70: return UIColor.Temperatures.cool
        case 70..<90: return UIColor.Temperatures.warm
        default: return UIColor.Temperatures.hot
        }
    }
}

extension UIColor {
    struct Temperatures {
        static var cold: UIColor { return UIColor(red: 224, green: 228, blue: 204) }
        static var chilly: UIColor { return UIColor(red: 167, green: 219, blue: 216) }
        static var cool: UIColor { return UIColor(red: 105, green: 210, blue: 231) }
        static var warm: UIColor { return UIColor(red: 243, green: 134, blue: 48) }
        static var hot: UIColor { return UIColor(red: 250, green: 105, blue: 0) }
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}
