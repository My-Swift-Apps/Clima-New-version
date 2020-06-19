//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
//for GPS we use CoreLocation
import CoreLocation

class WeatherViewController: UIViewController
{
    //Step 1 to get info from different file
    var weathermanager = WeatherManager()
    //the coreLocation that we imported we can assign it to valuable
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tempMax: UILabel!
    @IBOutlet weak var tempMin: UILabel!
    @IBOutlet weak var feelsLike: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        //step 2 after assigning the second file to this one
        weathermanager.delegate = self
        searchTextField.delegate = self
    }
    
    // for it to work dont forget to go to info.plist and add privacy location
    @IBAction func locationPressed(_ sender: UIButton)
    {
        locationManager.requestLocation()
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate
{
    /*
     for this delegate to work and it get the values that we want we have to add
     locationManager.delegate = self in the viewDidLoad Never fogert that because without it it will not work
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        //because last is option then we have to optional bind the whole thing
        if let location = locations.last
        {
            //this used to stop looking for another location once it already has one
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weathermanager.featchweatherURL(latitude: lat , longitude: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
         print("error")
    }
    
}
//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate
{
    @IBAction func searchPressed(_ sender: UIButton)
    {
        searchTextField.endEditing(true)
    }
    //checking if the searchBar is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //option to see if the searchBar has endEdition
        searchTextField.endEditing(true)
        return true
    }
    /*Asks the delegate if editing should stop in the specified text field.
     furthermore, the textField represent the textBar without needing to call
     the SearchTextField*/
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        //now checking if there was anything written in the textfield
        if (textField.text != "")
        {
            return true
        }
        else
        {
            textField.placeholder = "Please enter City"
            return false
        }
    }
    //Tells the delegate that editing stopped for the specified text field.
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        /*saving the returning value and to make sure it is not nil
         we will use optional blinding
         the value that it will be written in the text field will be saved and send
         to request it from waetherManager */
        if let City = searchTextField.text
        {
            //weathermanager is assigned in the weatherviewcontroller from WeatherManager
            //assign CityName to CITYNAME in the weathermanager featch func
            
            weathermanager.featchweatherURL(CITYNAME : City)
        }
        //now we have to return searchtext to be empty
        searchTextField.text = ""
    }
}
//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate
{
    func didUpdateWeather (_ weatherManger: WeatherManager, weather: WeatherModel)
    {
        DispatchQueue.main.async
        {
            //because it is closure we have to add "self" to it
            self.temperatureLabel.text = weather.TemperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            self.tempMax.text = "TempMax= \(weather.Temp_Max) C "
            self.tempMin.text = "TempMin= \(weather.Temp_Min) C"
            self.feelsLike.text = "Feels-Like= \(weather.Feels_Like) C "
            let pressureValue = String(format: "%.3f", weather.Pressur/1000)
            self.pressure.text = "Pressure= \(pressureValue) KP"
            self.humidity.text = "Humidity= \(weather.Humidity) g/m3"
            let windspeedValue = String(format: "%.2f",weather.Wind_speed * 18 / 5)
            self.windSpeed.text =  "Wind-Speed= \(windspeedValue) km/h"
        }
    }
    func didFallWithError( error : Error)
    {
        print(error )
    }
}


