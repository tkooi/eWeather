//
//  ViewController.swift
//  eWeather
//
//  Created by Thomas Kooi on 2/11/17.
//  Copyright © 2017 Thomas Kooi. All rights reserved.
//

import CoreLocation
import UIKit

import Alamofire
import SwiftyJSON


class ViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {


    // MARK: - Internal

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!

    @IBOutlet weak var temparatureLabel: UILabel!
    @IBOutlet weak var conditionsLabel: UILabel!

    @IBOutlet weak var unitSegmentedControl: UISegmentedControl!

    var weather: Weather? {

        didSet { updateWeather() }
    }

    @IBAction func searchByCurrentLocation(_ sender: UIButton) {

        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

        searchTextField.resignFirstResponder()
    }

    @IBAction func clearSearch(_ sender: UIButton) {

        resetWeather()
        searchTextField.becomeFirstResponder()
    }

    @IBAction func changeUnit(_ sender: UIButton) {

        updateWeather()
    }

    func setWeather(weather: Weather) {

        self.weather = weather
    }

    func updateWeather() {

        guard let city = weather?.city, let temperature = weather?.temperature, let description = weather?.conditions else {

            resetWeather()
            return
        }

        searchTextField.text = city

        let duration = 0.5

        UIView.animate(withDuration: duration, animations: { self.view.backgroundColor = temperature.color } )

        UIView.transition(with: self.temparatureLabel,
                          duration: duration,
                          options: .transitionCrossDissolve,
                          animations: { self.updateTemperature(temperature) },
                          completion: nil)

        UIView.transition(with: self.conditionsLabel,
                          duration: duration,
                          options: .transitionCrossDissolve,
                          animations: { self.conditionsLabel.text = description },
                          completion: nil)
        
        updateClearButton()
    }

    func resetWeather() {

        searchTextField.text = ""
        temparatureLabel.text = ""
        conditionsLabel.text = ""

        updateClearButton()
    }

    func cancelSearch() {

        searchTextField.resignFirstResponder()
        updateWeather()
    }

    func updateCurrentLocationButton() {
        guard CLLocationManager.locationServicesEnabled() else {

            self.currentLocationButton.isHidden = true
            return
        }

        switch CLLocationManager.authorizationStatus() {

        case .restricted, .denied:
            self.currentLocationButton.isHidden = true

        case .notDetermined, .authorizedAlways, .authorizedWhenInUse:
            self.currentLocationButton.isHidden = false
        }
    }

    func updateClearButton() {

        guard let searchIsEmpty = searchTextField.text?.isEmpty else { return }

        clearButton.isHidden = searchIsEmpty
    }

    func updateTemperature(_ temperature: Temperature) {

        let convertedTemperature = (self.unitSegmentedControl.selectedSegmentIndex == 0)
            ? temperature.fahrenheit()
            : temperature.celcius()

        self.temparatureLabel.text = convertedTemperature.format()
    }

    func presentError(_ error: Error) {

        switch error {

        case WeatherServiceError.weatherNotFound:
            presentAlert(title: "Weather Not Found", message: "Please try a different city or zip.", handler: { _ in self.searchTextField.becomeFirstResponder() })
        default:
            presentAlert(title: "Something Went Wrong", message: "Please try again later.")
        }
    }

    func presentAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: handler)

        alertController.addAction(action)

        self.present(alertController, animated: true, completion: nil)
    }


    // MARK: - UIViewController

    override func viewDidLoad() {

        super.viewDidLoad()

        locationManager.delegate = self

        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(updateClearButton), for: UIControlEvents.editingChanged)
        searchTextField.becomeFirstResponder()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cancelSearch))
        view.addGestureRecognizer(tap)

        updateWeather()
        updateCurrentLocationButton()
    }


    // MARK: - CCLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let coordinate = locations.first?.coordinate else { return }

        WeatherService.searchByCoordinate(latitude: coordinate.latitude, longitude: coordinate.longitude, success: setWeather, failure: presentError)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        presentAlert(title: "Location Not Found", message: "Please try again later.")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        updateCurrentLocationButton()
    }


    // MARK: - UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        searchTextField.resignFirstResponder()

        guard let query = searchTextField.text, !query.isEmpty else { return true }

        if let zipCode = Int(query) {
            WeatherService.searchByZipCode(zipCode, success: setWeather, failure: presentError)
        }
        else {
            WeatherService.searchByQuery(query, success: setWeather, failure: presentError)
        }

        return true
    }


    // MARK: - Private

    private let locationManager = CLLocationManager()
}
