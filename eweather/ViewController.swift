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
    @IBOutlet weak var conditionsLabel: UILabel!
    @IBOutlet var backgroundView: UIView!
    

    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var unitSegmentedControl: UISegmentedControl!

    let locationManager = CLLocationManager()
    
    var weather: Weather? {
        didSet {
            if let city = weather?.city, let temperature = weather?.temperature, let description = weather?.conditions {
                searchTextField.text = city
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.backgroundView.backgroundColor = temperature.color()
                }, completion: nil)
                
                UIView.transition(with: self.temparatureLabel,
                                  duration: 0.5,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    let convertedTemperature = (self.unitSegmentedControl.selectedSegmentIndex == 0)
                                    ? temperature.fahrenheit()
                                    : temperature.celcius()
                                    
                                    self.temparatureLabel.text = convertedTemperature.format()
                }, completion: nil)
                UIView.transition(with: self.conditionsLabel,
                                  duration: 0.5,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    
                                    self.conditionsLabel.text = description
                                    
                }, completion: nil)
                
            } else {
                temparatureLabel.text = nil
                conditionsLabel.text = nil
            }
        }
    }
    
    // TODO: Only show location button when we have location services available
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        searchTextField.delegate = self
        weather = nil
        clearButton.isHidden = (searchTextField.text?.isEmpty)!

        // Add a "textFieldDidChange" notification method to the text field control.
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
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
    
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        searchTextField.becomeFirstResponder()
    }

    @IBAction func changeUnit(_ sender: Any) {
        if let temperature = weather?.temperature {
            UIView.transition(with: self.temparatureLabel,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: {
                                if (self.unitSegmentedControl.selectedSegmentIndex == 0) {
                                    self.temparatureLabel.text = temperature.fahrenheit().format()
                                } else {
                                    self.temparatureLabel.text = temperature.celcius().format()
                                }
            }, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateWeatherOrError(_ result: Result<Weather>)
    {
        switch result {
        case .success(let value):
            self.weather = value
            clearButton.isHidden = (searchTextField.text?.isEmpty)!
        case .failure:
            self.temparatureLabel.text = nil
            self.conditionsLabel.text = "not found, please try again"
            searchTextField.becomeFirstResponder()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func searchByCurrentLocation(_ sender: Any) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        searchTextField.resignFirstResponder()
    }
    
    @IBAction func clearSearch(_ sender: Any) {
        
        searchTextField.text = nil
        clearButton.isHidden = (searchTextField.text?.isEmpty)!
        searchTextField.becomeFirstResponder()
    }
    
    // MARK: - CCLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.first?.coordinate {
            WeatherService.searchByCoordinate(latitude: coordinate.latitude, longitude: coordinate.longitude, completion: updateWeatherOrError)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // TODO: Implement Error Handling for Getting Current Location
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    // MARK: UITextFieldDelegate
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        searchTextField.resignFirstResponder()
        searchTextField.text = weather?.city
        clearButton.isHidden = (searchTextField.text?.isEmpty)!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let query = searchTextField.text, !query.isEmpty
        {
            if let zipCode = Int(query) {
                WeatherService.searchByZipCode(zipCode, completion: updateWeatherOrError)
            } else {
                WeatherService.searchByQuery(query, completion: updateWeatherOrError)
            }
        }
        
        searchTextField.resignFirstResponder()
        
        return true
    }
    
    
    func textFieldDidChange(_ textField: UITextField) {
        clearButton.isHidden = (searchTextField.text?.isEmpty)!
    }
}
