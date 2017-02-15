//
//  TemperatureTests.swift
//  eWeather
//
//  Created by Thomas Kooi on 2/15/17.
//  Copyright © 2017 Thomas Kooi. All rights reserved.
//

import XCTest
@testable import eWeather


class TemperatureTests: XCTestCase {

    func testFormatTemperature() {

        XCTAssertEqual(Temperature(-10).format(), "-10°")
        XCTAssertEqual(Temperature(-10.2342352536262642).format(), "-10°")
        XCTAssertEqual(Temperature(-10.5).format(), "-11°")
        XCTAssertEqual(Temperature(-10.4).format(), "-10°")
        XCTAssertEqual(Temperature(-10.0).format(), "-10°")
        XCTAssertEqual(Temperature(-10.00).format(), "-10°")
        XCTAssertEqual(Temperature(0).format(), "0°")
        XCTAssertEqual(Temperature(0.0).format(), "0°")
        XCTAssertEqual(Temperature(1).format(), "1°")
        XCTAssertEqual(Temperature(1.0).format(), "1°")
        XCTAssertEqual(Temperature(51.4).format(), "51°")
        XCTAssertEqual(Temperature(52.5).format(), "53°")
    }

    func testKelvinToFarenheitTemperatureConversion() {

        let expected = Temperature(80.33, unit: .fahrenheit).value
        let converted = Temperature(300, unit: .kelvin).fahrenheit().value

        XCTAssertGreaterThanOrEqual(expected + 0.01, converted)
        XCTAssertGreaterThanOrEqual(converted + 0.01, expected)
    }

    func testKelvinToCelciusTemperatureConversion() {

        let expected = Temperature(26.85, unit: .celcius).value
        let converted = Temperature(300, unit: .kelvin).celcius().value

        XCTAssertGreaterThanOrEqual(expected + 0.01, converted)
        XCTAssertGreaterThanOrEqual(converted + 0.01, expected)
    }

    func testFarenheitToCelciusTemperatureConversion() {

        let expected = Temperature(20, unit: .celcius).value
        let converted = Temperature(68, unit: .fahrenheit).celcius().value

        XCTAssertGreaterThanOrEqual(expected + 0.01, converted)
        XCTAssertGreaterThanOrEqual(converted + 0.01, expected)
    }

    func testCelciusToFarenheitTemperatureConversion() {

        let expected = Temperature(68, unit: .fahrenheit).value
        let converted = Temperature(20, unit: .celcius).fahrenheit().value

        XCTAssertGreaterThanOrEqual(expected + 0.01, converted)
        XCTAssertGreaterThanOrEqual(converted + 0.01, expected)
    }

    func testTemperatureEquatable() {

        XCTAssertEqual(Temperature(42.2), Temperature(42.2))
        XCTAssertNotEqual(Temperature(42.2, unit: .celcius), Temperature(42.2, unit: .fahrenheit))
    }
}
