//
//  weatherManager.swift
//  Clima
//
//  Created by Mero on 2020-05-07.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
//for GPS we use CoreLocation
import CoreLocation

//we create the protocol in the same file as we will use the protocol
protocol WeatherManagerDelegate
{
    //weatherModel will contain the initialization for info we require from the wibesite
    func didUpdateWeather(_ weatherManger: WeatherManager, weather: WeatherModel)
    //the input is error of type Error
    func didFallWithError( error : Error)
}
//MARK: - WeatherManager
struct WeatherManager
{
    //First the Weather URl that will bring the info that we need
    let WeatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=a61085bb415c06e8a8f7a4d1735dd811&units=metric"
    //assign the protocol to var delegate and we have to add ? to make sure that it will not return nil
    // and we are making delegate from the same type as the protocol
    var delegate : WeatherManagerDelegate?
    //func that we have the name of the city added to the URL to bring back the weather of this city
    
//MARK: - featchWeather with city name
    func featchweatherURL (CITYNAME : String)
    {
        //saving the URL with the name of the city in a string
        let FullURL = "\(WeatherURL)&q=\(CITYNAME)"
        //send this info to get the request the jason file from the wensite
        print(FullURL)
        performRequest(with: FullURL)
    }
//MARK: - featchWeather with city long and lat
    func featchweatherURL (latitude: CLLocationDegrees , longitude: CLLocationDegrees)
    {
        //saving the URL with the name of the city in a string
        let FullURL = "\(WeatherURL)&lat=\(latitude)&lon=\(longitude)"
        //send this info to get the request the jason file from the wensite
        performRequest(with: FullURL)
        print(FullURL)
    }
 
 //MARK: - performResquest
    //with is for external usage and urlString is for internal usage
    func performRequest (with urlString: String )
    {
        //Step 1 to send the url and get the info
        if let url = URL (string: urlString)
        {
            //step 2 create a URLSession
            let Session = URLSession(configuration: .default)
            //step 3 give the session a task whcih is to go to a browser and use the URL
            let Task = Session.dataTask(with: url)
            {
                (data, response, error)
                in
                // In case the website return nothin
                if error != nil
                {
                    /* from the protocl that we created in the begining of the page we will use that to check that there is no error
                        Furthermore, because we are using clossure we have to use slef
                     */
                    self.delegate?.didFallWithError(error: error!)
                    return
                }
                
                // Now get the info fromt the JASON func that will be created later to return it to the weather info if it is not nil
                if let ReturnedData = data
                {
                    //using closure we have to use self to include a method that is inside the same class
                    //using optional binding is checked to see if it's nil or has data. If it's nil, the if-statement just doesn't get executed. If there's data, the data gets unwrapped and assigned to constantName for the scope of the if-statement. Then the code inside the braces is executed.
                    if let weather =  self.parseJASON(ReturnedData)
                    {
                        //Step 3) and we have to use self to specifiy that we are in the same class
                        self.delegate?.didUpdateWeather(  self, weather: weather)
                    }
                }
            }
            // Step 4 Start the task which basically hitting enter in the search bar to go to the webpage with the info
            Task.resume()
        }
    }

//MARK: - JASON
//the reason we choose the return to be weatherModel datatype because that is what weather is created from
    func parseJASON (_ weatherdata: Data) -> WeatherModel?
    {
        //creating a constant that will contain decoraded data in a jason form
        let Decoder = JSONDecoder()
        do
        {
            //the first argument is from the file WeatherData and the second is the inner intializer in the pramater
            let DecoderData = try Decoder.decode(WeatherData.self, from: weatherdata)
            /* from a file that is created called weatherdata it will
             contain the path to the required info from the jason file
             that was created and assign it to the initizaled variables the
             was initialized in the weatherModul file */
            let id = DecoderData.weather[0].id
            let temp = DecoderData.main.temp
            let name = DecoderData.name
            let temp_max = DecoderData.main.temp_max
            let temp_min = DecoderData.main.temp_min
            let feels_like = DecoderData.main.feels_like
            let pressure = DecoderData.main.pressure
            let humidity = DecoderData.main.humidity
            let wind_speed = DecoderData.wind.speed
            
            //now we will assign the value that we got from the Jason file which is from the WeatherData to assign it to the variables in the WeatherModel
            let WEATHER = WeatherModel(conditionId: id,cityName: name,temperature: temp,Temp_Max: temp_max,Temp_Min: temp_min,Feels_Like: feels_like,Pressur: pressure,Humidity: humidity,Wind_speed: wind_speed)
            return WEATHER
        }
        catch
        {
            delegate?.didFallWithError(error: error)
                     //for us to return nil we have to make our weatherModul as optional by adding ?
                     return nil
        }
    }
}
