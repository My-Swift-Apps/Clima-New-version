//
//  WeatherModel.swift
//  Clima
//
//  Created by Mero on 2020-05-07.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel
{
    
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    let Temp_Max: Double
    let Temp_Min: Double
    let Feels_Like: Double
    let Pressur: Double
    let Humidity: Double
    let Wind_speed: Double
    // now creating other cariable that will help us to get info that will be used to change the button in the user interface in the app
    var TemperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    
    var conditionName : String
    {
        switch conditionId
        {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
}
