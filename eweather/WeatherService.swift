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
    static func getWeather(query: String, completionHandler: @escaping (WeatherCondition) -> ()) {
        let weatherEndPoint = "http://api.openweathermap.org/data/2.5/weather"
        
        let parameters = [
            "APPID": "95d190a434083879a6398aafd54d9e73",
            "units": "imperial",
            "q": query
        ];
        
        Alamofire.request(weatherEndPoint, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value);
                let newWeatherCondition = WeatherCondition(
                    city: json["name"].string!,
                    temperature: json["main"]["temp"].double!,
                    description: json["weather"][0]["description"].string!
                )
                
                completionHandler(newWeatherCondition)
            case .failure(let error):
                print(error)
            }
        }
    }
}
