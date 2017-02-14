//
//  WeatherService.swift
//  eweather
//
//  Created by Thomas Kooi on 2/11/17.
//  Copyright © 2017 Thomas Kooi. All rights reserved.
//

import Foundation

import Alamofire
import SwiftyJSON


class WeatherService {

    // MARK: Internal

    static func searchByCoordinate(latitude: Double, longitude: Double, completion: @escaping (Result<Weather>) -> ()) {
        let parameters = [
            "APPID": openWeatherAPIKey,
            "lat": String(latitude),
            "lon": String(longitude)
        ]
        
        requestWeather(parameters: parameters, completion: completion)
    }

    static func searchByQuery(_ query: String, completion: @escaping (Result<Weather>) -> ()) {
        let parameters = [
            "APPID": openWeatherAPIKey,
            "q": query
        ]

        requestWeather(parameters: parameters, completion: completion)
    }

    static func searchByZipCode(_ zipCode: Int, completion: @escaping (Result<Weather>) -> ()) {
        let parameters = [
            "APPID": openWeatherAPIKey,
            "zip": String(zipCode)
        ]

        requestWeather(parameters: parameters, completion: completion)
    }


    // MARK: Private

    private static func requestWeather(parameters: [String: String], completion: @escaping (Result<Weather>) -> ()) {

        Alamofire.request(openWeatherEndPoint, parameters: parameters)
            .validate()
            .responseJSON { response in handleResult(response.result, completion: completion) }
    }
    
    private static func handleResult(_ result: Result<Any>, completion: @escaping (Result<Weather>) -> ()) {
        switch result {

        case .success(let value):
            let json = JSON(value);

            if let city = json["name"].string, let temperature = json["main"]["temp"].double, let conditions = json["weather"][0]["description"].string {

                let weather = Weather(city: city, temperature: Temperature(temperature), conditions: conditions)

                completion(.success(weather))
            }

        case .failure(let error):
            completion(.failure(error))
        }
    }

    private static let openWeatherEndPoint = "http://api.openweathermap.org/data/2.5/weather"
    private static let openWeatherAPIKey = "95d190a434083879a6398aafd54d9e73"
}
