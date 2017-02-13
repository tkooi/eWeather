//
//  Temperature.swift
//  eweather
//
//  Created by Thomas Kooi on 2/12/17.
//  Copyright © 2017 Thomas Kooi. All rights reserved.
//

import Foundation

enum TemperatureUnit {
    case kelvin, celcius, fahrenheit
}

struct Temperature: Equatable {
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
