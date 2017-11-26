//
//  WindObject.swift
//  WeatherNow
//
//  Created by Lawrence Herb on 11/25/17.
//  Copyright © 2017 Larry Herb. All rights reserved.
//

import Foundation

struct WindObject {
    let speed: Double;
    let degrees: Double;
    let gust: Double;
    
    init(dictionary: [String: Any]) {
        //Initiate Object with Default Values
        
        self.speed = dictionary["speed"] as? Double ?? 0.0;
        self.degrees = dictionary["deg"] as? Double ?? 0.0;
        self.gust = dictionary["gust"] as? Double ?? 0.0;
    }
}
