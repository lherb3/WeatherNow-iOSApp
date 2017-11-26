//
//  CoordinateObject.swift
//  WeatherNow
//
//  Created by Lawrence Herb on 11/25/17.
//  Copyright © 2017 Larry Herb. All rights reserved.
//

import Foundation

struct CoordinateObject {
    let latitude: Double;
    let longitude: Double;
    
    init(dictionary: [String: Any]) {
        //Initiate Object with Default Values
        
        self.latitude = dictionary["lat"] as? Double ?? 0.0;
        self.longitude = dictionary["lon"] as? Double ?? 0.0;
    }
    
}
