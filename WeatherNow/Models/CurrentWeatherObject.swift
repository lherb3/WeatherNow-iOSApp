//
//  CurrentWeatherObject.swift
//  WeatherNow
//
//  Created by Lawrence Herb on 11/24/17.
//  Copyright © 2017 Larry Herb. All rights reserved.
//

import Foundation

struct CurrentWeatherObject {
    //Declare Variable Here
    
    let coordinate: CoordinateObject;
    var weatherConditionsArray : [WeatherObject] = [];
    let base: String;
    let weatherOverview: MainWeatherInfoObject;
    let visibility: Int;
    let wind: WindObject;
    let identifier: Int;
    let dt: Int;
    let cityName: String;
    let httpCode: Int;
    
    init(dictionary: [String: Any]) {
        //Initiate Object with Default Values
        
        self.coordinate = CoordinateObject(dictionary: dictionary["coord"] as? [String:Any] ?? [:]);
        let weatherJSON = dictionary["weather"] as? [Any];
        if(weatherJSON?.count==0){
            //Nothing in Conditions
        }else{
            if(weatherJSON==nil){
                //Nothing in Conditions
            }else{
                for weather in weatherJSON!{
                    weatherConditionsArray.append(WeatherObject(dictionary: weather as! [String:Any] ));
                }
            }
        }
        self.base = dictionary["base"] as? String ?? "";
        self.weatherOverview = MainWeatherInfoObject(dictionary: dictionary["main"] as? [String:Any] ?? [:]);
        self.visibility = dictionary["visibility"] as? Int ?? 0;
        self.wind = WindObject(dictionary: dictionary["wind"] as? [String:Any] ?? [:]);
        self.identifier = dictionary["id"] as? Int ?? 0;
        self.dt = dictionary["dt"] as? Int ?? 0;
        self.cityName = dictionary["name"] as? String ?? "";
        self.httpCode = dictionary["cod"] as? Int ?? 0;
    }
    
    init?(json: String) {
        self.init(data: Data(json.utf8))
    }
    init?(data: Data) {
        guard let json = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] else { return nil }
        self.init(dictionary: json)
    }
}
