//
//  WeatherService.swift
//  eWeather
//
//  Created by Thomas Kooi on 2/11/17.
//  Copyright © 2017 Thomas Kooi. All rights reserved.
//

import Foundation

import Alamofire
import SwiftyJSON

class WeatherService {


    // MARK: - Internal

    static func searchByCoordinate(latitude: Double, longitude: Double, success: @escaping (Weather) -> (), failure: @escaping (Error) -> ()) {
        let parameters = [
            "APPID": openWeatherAPIKey,
            "lat": String(latitude),
            "lon": String(longitude)
        ]

        requestWeather(parameters: parameters, success: success, failure: failure)
    }

    static func searchByQuery(_ query: String, success: @escaping (Weather) -> (), failure: @escaping (Error) -> ()) {
        let parameters = [
            "APPID": openWeatherAPIKey,
            "q": query
        ]

        requestWeather(parameters: parameters, success: success, failure: failure)
    }

    static func searchByZipCode(_ zipCode: Int, success: @escaping (Weather) -> (), failure: @escaping (Error) -> ()) {
        let parameters = [
            "APPID": openWeatherAPIKey,
            "zip": String(zipCode)
        ]

        requestWeather(parameters: parameters, success: success, failure: failure)
    }


    // MARK: - Private

    private static func requestWeather(parameters: [String: String], success: @escaping (Weather) -> (), failure: @escaping (Error) -> ()) {

        Alamofire.request(openWeatherEndPoint, parameters: parameters)
            .validate()
            .responseJSON { response in

                switch response.result {

                case .success(let value):
                    let json = JSON(value)

                    guard let city = json["name"].string,
                        let temperature = json["main"]["temp"].double,
                        let conditions = json["weather"][0]["description"].string
                    else { return }

                    let weather = Weather(city: city, temperature: Temperature(temperature), conditions: conditions)

                    success(weather)

                case .failure(let error):
                    switch error {

                    case Alamofire.AFError.responseValidationFailed: failure(WeatherServiceError.weatherNotFound)
                    default: failure(error)
                    }
                }
        }
    }

    private static let openWeatherEndPoint = "http://api.openweathermap.org/data/2.5/weather"
    private static let openWeatherAPIKey = "95d190a434083879a6398aafd54d9e73"
}

enum WeatherServiceError : Error {
    case weatherNotFound
}
