//
//  eweatherTests.swift
//  eweatherTests
//
//  Created by Thomas Kooi on 2/11/17.
//  Copyright © 2017 Thomas Kooi. All rights reserved.
//

import XCTest
@testable import eweather

class eweatherTests: XCTestCase {
    var vc: ViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        vc = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! ViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLabelsShowCorrectValues() {
        // Initialize the view
        let _ = vc.view
        
        vc.weatherCondition = WeatherCondition(city: "London", temperature: 45.2, description: "light rain")
        
        XCTAssertEqual(vc.cityName.text, "London")
        XCTAssertEqual(vc.temparature.text, "45.2")
        XCTAssertEqual(vc.weatherDescription.text, "light rain")
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
