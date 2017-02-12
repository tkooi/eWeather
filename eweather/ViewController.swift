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

class ViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temparature: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    
    var weatherCondition: WeatherCondition? {
        didSet {
            cityName.text = weatherCondition!.city
            temparature.text = String(weatherCondition!.temperature)
            weatherDescription.text = weatherCondition!.description
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func go(_ sender: Any) {
        if let query = searchTextField.text, !query.isEmpty
        {
            let completionHandler = { (weatherCondition: WeatherCondition) -> () in
                self.weatherCondition = weatherCondition
            }
            
            WeatherService.getWeather(query: query, completionHandler: completionHandler)
        }
    }
}
