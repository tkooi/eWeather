//
//  ViewController.swift
//  eweather
//
//  Created by Thomas Kooi on 2/11/17.
//  Copyright © 2017 Thomas Kooi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class ViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var temparatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet var backgroundView: UIView!

    let locationManager = CLLocationManager()
    
    var weatherCondition: WeatherCondition? {
        didSet {
            if let city = weatherCondition?.city, let temperature = weatherCondition?.temperature, let description = weatherCondition?.description {
                searchTextField.text = city
                temparatureLabel.text = temperature.fahrenheit().format()
                descriptionLabel.text = description
            } else {
                // TODO: Implement not found
            }

        }
    }
    
    func formatTemperature(_ temperature: Double) -> String {
        return "\(Int(round(temperature)))°"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        searchTextField.delegate = self
        
//        if CLLocationManager.locationServicesEnabled() {
//            switch(CLLocationManager.authorizationStatus()) {
//            case .notDetermined, .restricted, .denied:
//                print("No access")
//            case .authorizedAlways, .authorizedWhenInUse:
//                print("Access")
//            }
//        } else {
//            print("Location services are not enabled")
//        }
    
        searchTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        UIView.animate(withDuration: 5.0) { 
//            self.backgroundView.backgroundColor = UIColor(red:0.98, green:0.41, blue:0.00, alpha:1.0)
//        }
//    }
    
    @IBAction func searchByCurrentLocation(_ sender: Any) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        searchTextField.resignFirstResponder()
    }
    
    func updateWeatherCondition(weatherCondition: WeatherCondition)
    {
        self.weatherCondition = weatherCondition
    }
    
    // MARK: - CCLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.first?.coordinate {
            WeatherService.getWeather(latitude: coordinate.latitude, longitude: coordinate.longitude, completion: updateWeatherCondition)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // TODO: Implement Error Handling for Getting Current Location
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let query = searchTextField.text, !query.isEmpty
        {
            WeatherService.getWeather(query: query, completion: updateWeatherCondition)
        }
        
        searchTextField.resignFirstResponder()
        
        return true
    }
}
