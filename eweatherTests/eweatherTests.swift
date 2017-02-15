//
//  eweatherTests.swift
//  eweatherTests
//
//  Created by Thomas Kooi on 2/11/17.
//  Copyright © 2017 Thomas Kooi. All rights reserved.
//

import XCTest
@testable import eweather

// TODO: Refactor Tests
class eweatherTests: XCTestCase {
    var vc: ViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        vc = storyboard.instantiateInitialViewController() as! ViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLabelsShowCorrectText() {
        // Initialize the view
        let _ = vc.view
        
        vc.weather = Weather(city: "London", temperature: Temperature(45.2, unit: .fahrenheit), conditions: "light rain")
        
        // TODO: Add descriptions for failed tests
        XCTAssertEqual(vc.searchTextField.text, "London")
        XCTAssertEqual(vc.temparatureLabel.text, "45°")
        XCTAssertEqual(vc.conditionsLabel.text, "light rain")
    }
    
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
    
    func testTemperatureConversions() {
        // TODO: Figure out how to test conversions even with Double imprecision
        XCTAssertEqual(Temperature(300).fahrenheit(), Temperature(80.33, unit: .fahrenheit))
        // T(°C) = 300K - 273.15 = 26.85 °C
        // T(°C) = (68°F - 32) × 5/9 = 20 °C
        // T(°F) = 300K × 9/5 - 459.67	= 80.33 °F
        // T(°F) = 20°C × 9/5 + 32 = 68 °F
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
