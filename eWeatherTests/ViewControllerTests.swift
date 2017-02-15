//
//  ViewControllerTests.swift
//  eWeatherTests
//
//  Created by Thomas Kooi on 2/11/17.
//  Copyright © 2017 Thomas Kooi. All rights reserved.
//

import XCTest
@testable import eWeather


class ViewControllerTests: XCTestCase {

    var vc: ViewController!

    override func setUp() {

        super.setUp()

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        vc = storyboard.instantiateInitialViewController() as! ViewController

        // Initialize the view
        let _ = vc.view
    }

    func testLabelsShowCorrectTextForWeatherWithFahrenheitTemperature() {

        vc.weather = Weather(city: "London", temperature: Temperature(45.2, unit: .fahrenheit), conditions: "light rain")
        vc.unitSegmentedControl.selectedSegmentIndex = 0

        XCTAssertEqual(vc.searchTextField.text, "London")
        XCTAssertEqual(vc.temparatureLabel.text, "45°")
        XCTAssertEqual(vc.conditionsLabel.text, "light rain")
    }

    func testLabelsShowCorrectTextForWeatherWithCelciusTemperatureAfterChangingUnit() {

        vc.weather = Weather(city: "London", temperature: Temperature(32.0, unit: .fahrenheit), conditions: "light rain")
        vc.unitSegmentedControl.selectedSegmentIndex = 1

        vc.changeUnit(UIButton())

        XCTAssertEqual(vc.searchTextField.text, "London")
        XCTAssertEqual(vc.temparatureLabel.text, "0°")
        XCTAssertEqual(vc.conditionsLabel.text, "light rain")
    }

    func testLabelsShowCorrectTextForWeatherWithFahrenheitTemperatureAfterChangingUnitToCelciusAndBack() {

        vc.weather = Weather(city: "London", temperature: Temperature(32.0, unit: .fahrenheit), conditions: "light rain")
        vc.unitSegmentedControl.selectedSegmentIndex = 1

        vc.changeUnit(UIButton())

        vc.unitSegmentedControl.selectedSegmentIndex = 0

        vc.changeUnit(UIButton())

        XCTAssertEqual(vc.searchTextField.text, "London")
        XCTAssertEqual(vc.temparatureLabel.text, "32°")
        XCTAssertEqual(vc.conditionsLabel.text, "light rain")
    }

    func testLabelsShowCorrectTextForNoWeather() {

        vc.weather = nil

        XCTAssertEqual(vc.searchTextField.text, "")
        XCTAssertEqual(vc.temparatureLabel.text, "")
        XCTAssertEqual(vc.conditionsLabel.text, "")
    }

    func testClearButtonIsHiddenWhenSearchTextFieldIsEmpty() {

        vc.searchTextField.text = ""

        vc.updateClearButton()

        XCTAssert(vc.clearButton.isHidden)
    }

    func testClearButtonIsHiddenWhenSearchTextFieldHasText() {

        vc.searchTextField.text = "London"

        vc.updateClearButton()

        XCTAssert(!vc.clearButton.isHidden)
    }

    func testBackgroundColorIsCorrectForVariousTemperatures() {

        vc.weather = Weather(city: "London", temperature: Temperature(-1.0, unit: .fahrenheit), conditions: "light rain")
        XCTAssertEqual(vc.view.backgroundColor, UIColor.Temperatures.cold)

        vc.weather = Weather(city: "London", temperature: Temperature(32.0, unit: .fahrenheit), conditions: "light rain")
        XCTAssertEqual(vc.view.backgroundColor, UIColor.Temperatures.chilly)

        vc.weather = Weather(city: "London", temperature: Temperature(40.0, unit: .fahrenheit), conditions: "light rain")
        XCTAssertEqual(vc.view.backgroundColor, UIColor.Temperatures.chilly)

        vc.weather = Weather(city: "London", temperature: Temperature(55.7, unit: .fahrenheit), conditions: "light rain")
        XCTAssertEqual(vc.view.backgroundColor, UIColor.Temperatures.cool)

        vc.weather = Weather(city: "London", temperature: Temperature(72.2, unit: .fahrenheit), conditions: "light rain")
        XCTAssertEqual(vc.view.backgroundColor, UIColor.Temperatures.warm)

        vc.weather = Weather(city: "London", temperature: Temperature(105.5, unit: .fahrenheit), conditions: "light rain")
        XCTAssertEqual(vc.view.backgroundColor, UIColor.Temperatures.hot)
    }
}
