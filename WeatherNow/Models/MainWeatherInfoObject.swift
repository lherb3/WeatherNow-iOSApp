//
//  MainWeatherInfoObject.swift
//  WeatherNow
//
//  Created by Lawrence Herb on 11/25/17.
//  Copyright © 2017 Larry Herb. All rights reserved.
//

import Foundation

struct MainWeatherInfoObject {
    let temperatureKelvin : Double;
    let pressure : Int;
    let humidity : Int;
    let temperatureKelvinMin : Double;
    let temperatureKelvinMax : Double;
    
    init(dictionary: [String: Any]) {
        //Initiate Object with Default Values
        
        self.temperatureKelvin = dictionary["temp"] as? Double ?? 0.0;
        self.pressure = dictionary["pressure"] as? Int ?? 0;
        self.humidity = dictionary["humidity"] as? Int ?? 0;
        self.temperatureKelvinMin = dictionary["temp_min"] as? Double ?? 0.0;
        self.temperatureKelvinMax = dictionary["temp_max"] as? Double ?? 0.0;
    }
}
