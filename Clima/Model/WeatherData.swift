//
//  WeatherData.swift
//  Clima
//
//  Created by Mero on 2020-05-08.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
// from the jason file that was open in chrom you can get the path as it will be shown in the following code
//Codable is a compination of both decodable and encodable
struct WeatherData: Codable
{
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
}

struct Main: Codable
{
    let temp : Double
    let temp_max : Double
    let temp_min : Double
    let feels_like : Double
    let pressure : Double
    let humidity : Double
}
struct Wind: Codable
{
    let speed : Double
}
struct Weather: Codable
{
    let description: String
    let id: Int
}
