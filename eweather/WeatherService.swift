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

// TODO: Implement searchByZip

class WeatherService {
    static let weatherEndPoint = "http://api.openweathermap.org/data/2.5/weather"
    static let openWeatherAPIKey = "95d190a434083879a6398aafd54d9e73"
    
    static func searchByZipCode(_ zipCode: Int, completion: @escaping (Result<Weather>) -> ()) {
        let parameters = [
            "APPID": openWeatherAPIKey,
            "zip": String(zipCode)
        ]
        
        Alamofire.request(weatherEndPoint, parameters: parameters)
            .validate()
            .responseJSON { response in handleResult(response.result, completion: completion) }
    }
    
    static func searchByQuery(_ query: String, completion: @escaping (Result<Weather>) -> ()) {
        let parameters = [
            "APPID": openWeatherAPIKey,
            "q": query
        ]
        
        Alamofire.request(weatherEndPoint, parameters: parameters)
            .validate()
            .responseJSON { response in handleResult(response.result, completion: completion) }
    }
    
    static func searchByCoordinate(latitude: Double, longitude: Double, completion: @escaping (Result<Weather>) -> ()) {
        let parameters = [
            "APPID": openWeatherAPIKey,
            "lat": String(latitude),
            "lon": String(longitude)
        ]

        Alamofire.request(weatherEndPoint, parameters: parameters)
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
}
