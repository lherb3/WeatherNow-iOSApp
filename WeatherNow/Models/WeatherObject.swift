//
//  WeatherObject.swift
//  WeatherNow
//
//  Created by Lawrence Herb on 11/25/17.
//  Copyright © 2017 Larry Herb. All rights reserved.
//

import Foundation

struct WeatherObject {
    let identifier: Int;
    let conditionLabel: String;
    let description: String;
    let iconCode: String;
    
    init(dictionary: [String: Any]) {
        //Initiate Object with Default Values
        
        self.identifier = dictionary["id"] as? Int ?? 0;
        self.conditionLabel = dictionary["main"] as? String ?? "";
        self.description = dictionary["description"] as? String ?? "";
        self.iconCode = dictionary["icon"] as? String ?? "";
        
    }
}
