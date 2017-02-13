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

struct Location: Equatable {
    let latitude: Double
    let longitude: Double
    
    public static func ==(lhs: Location, rhs: Location) -> Bool {
        return lhs.latitude == rhs.latitude
            && lhs.longitude == lhs.longitude
    }
}

class WeatherService {
    static let weatherEndPoint = "http://api.openweathermap.org/data/2.5/weather"
    
    static func getWeather(query: String, completion: @escaping (WeatherCondition) -> ()) {
        let parameters = [
            "APPID": "95d190a434083879a6398aafd54d9e73",
            "q": query
        ];
        
        Alamofire.request(weatherEndPoint, parameters: parameters).responseJSON { response in
            switch response.result {
                
            case .success(let value):
                let json = JSON(value);
                
                let city = json["name"].string!
                let temperature = Temperature(json["main"]["temp"].double!)
                let description = json["weather"][0]["description"].string!
                
                let weatherCondition = WeatherCondition(city: city, temperature: temperature, description: description)
                
                completion(weatherCondition)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func getWeather(latitude: Double, longitude: Double, completion: @escaping (WeatherCondition) -> ()) {
        let parameters = [
            "APPID": "95d190a434083879a6398aafd54d9e73",
            "lat": String(latitude),
            "lon": String(longitude)
        ];

        Alamofire.request(weatherEndPoint, parameters: parameters).responseJSON { response in
            switch response.result {
                
            case .success(let value):
                let json = JSON(value);
                
                let city = json["name"].string!
                let temperature = Temperature(json["main"]["temp"].double!)
                let description = json["weather"][0]["description"].string!
                
                let weatherCondition = WeatherCondition(city: city, temperature: temperature, description: description)
                
                completion(weatherCondition)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
