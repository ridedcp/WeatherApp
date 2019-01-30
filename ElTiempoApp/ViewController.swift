//
//  ViewController.swift
//  ElTiempoApp
//
//  Created by Daniel Cano on 31/8/18.
//  Copyright © 2018 Daniel Cano. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController, MeteoData {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var cityTextfield: UITextField!
    @IBOutlet weak var currentCityLabel: UILabel!
    @IBOutlet weak var cloudinessLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var currentCityButton: UIButton!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var motivationalSentence: UILabel!
    @IBOutlet weak var localTime: UILabel!
    @IBOutlet weak var sensationTemperature: UILabel!
    @IBOutlet weak var UVIndexLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var moreDataView: UIView!
    @IBOutlet weak var windyIcon: UIImageView!
    @IBOutlet weak var humidityIcon: UIImageView!
    @IBOutlet weak var horizontalLine: UIView!
    @IBOutlet weak var verticalLine: UIView!
    var weather: Weather!
    var time: Time!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        firstLaunch()
    }
    
    
    fileprivate func firstLaunch() {
        
        self.HideOrShowLabels(true)
        self.hideKeyboardWhenTappedAround()
        self.hideActivityIndicator(false)
        
        goButton.personalizedButtons()
        currentCityButton.personalizedButtons()
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore
        {
            print("Not first launch.")
            
            if NSUserDefaultManager.sharedInstance.existKeyInUserDefaults(key: "city") == true
            {
                self.currentCityLabel.text = NSUserDefaultManager.sharedInstance.recoverData(key: "city")
                getLastCityCurrentWeather(completion: {
                    
                    self.hideActivityIndicator(true)
                    self.HideOrShowLabels(false)
                })
            }
            else
            {
                getCurrentCityWeather()
                self.hideActivityIndicator(true)
                self.HideOrShowLabels(false)
            }
        }
        else
        {
            getCurrentCityWeather()
            self.hideActivityIndicator(true)
            self.HideOrShowLabels(false)
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
    }
    
    
    
    
    //MARK - ConfigureUI
    private func HideOrShowLabels(_ bool: Bool)
    {
    
        if bool
        {
            self.cloudinessLabel.isHidden = true
            self.windLabel.isHidden = true
            self.humidityLabel.isHidden = true
            self.moreDataView.isHidden = true
            self.horizontalLine.isHidden = true
            self.verticalLine.isHidden = true
            self.windyIcon.isHidden = true
            self.humidityIcon.isHidden = true
        }
        else
        {
            self.cloudinessLabel.isHidden = false
            self.windLabel.isHidden = false
            self.humidityLabel.isHidden = false
            self.moreDataView.isHidden = false
            self.horizontalLine.isHidden = false
            self.verticalLine.isHidden = false
            self.windyIcon.isHidden = false
            self.humidityIcon.isHidden = false
        }
    }
    
    private func hideActivityIndicator(_ bool: Bool)
    {
        if bool
        {
            self.activity.isHidden = true
            self.activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
        else
        {
            self.activity.isHidden = false
            self.activity.startAnimating()
            self.view.isUserInteractionEnabled = false
        }
    }
        
    
    @objc fileprivate func getLastCityCurrentWeather(completion: @escaping () -> Void)
    {
        self.hideActivityIndicator(false)
        
        if NSUserDefaultManager.sharedInstance.existKeyInUserDefaults(key: "city") == true
        {
            self.currentCityLabel.text = NSUserDefaultManager.sharedInstance.recoverData(key: "city")
            self.cityTextfield.text = NSUserDefaultManager.sharedInstance.recoverData(key: "city")
            
            let textFieldText = cityTextfield.text
            
            if textFieldText != "" && textFieldText != nil
            {
                Geolocation.shared.getLocation { (lat, long) in
                    
                    GeolocationInverse.shared.getCoordinateFromCity(cityString: textFieldText!) { (placemarks, error) in
                        
                        GeolocationInverse.shared.getAdressFromCoordinate(latitud: placemarks.latitude, longitud: placemarks.longitude) { completeCloruse in
                            
                            self.currentCityLabel.text = completeCloruse.uppercased()
                        }
                        
                        ConnectionsWrapper.sharedInstance.getUrl(latitud: placemarks.latitude, longitud: placemarks.longitude, delegate: self, completion: {
                            
                            DispatchQueue.main.async {
                            
                                self.HideOrShowLabels(false)
                                self.hideActivityIndicator(true)
                            }
                        })
                     
                        ConnectionsWrapper.sharedInstance.getUrlForTime(latitud: placemarks.latitude, longitud: placemarks.longitude, delegate: self, completion: {
                            
                            DispatchQueue.main.async {
                                
                                self.HideOrShowLabels(false)
                                self.hideActivityIndicator(true)
                            }
                            
                        })
                    }
                }
            }
        }
    }
    
    

    @objc fileprivate func getCurrentCityWeather()
    {
        self.dismissKeyboard()
        
        self.hideActivityIndicator(false)
        
        Geolocation.shared.getLocation { (lat, long) in
            
            print("La latitud actual es \(lat) y la longitud es \(long)")
            
            GeolocationInverse.shared.getAdressFromCoordinate(latitud: lat, longitud: long) { completeCloruse in //completeClosure contiene el dato que nos devuelve el escape
                
                print("La localización inversa es: \(completeCloruse)")
                
                
                self.currentCityLabel.text = completeCloruse.uppercased()
                self.cityTextfield.text = completeCloruse
                
                ConnectionsWrapper.sharedInstance.getUrl(latitud: lat, longitud: long, delegate: self, completion: {})
                
                ConnectionsWrapper.sharedInstance.getUrlForTime(latitud: lat, longitud: long, delegate: self, completion: {})
                
                self.hideActivityIndicator(true)
                
                print("Recuperando datos: \(completeCloruse)")
            }
        }
    }
    
    @IBAction func CurrentCityWeatherButton(_ sender: Any)
    {
        getCurrentCityWeather()
    }
    
    
    @IBAction func goButton(_ sender: Any)
    {
        self.dismissKeyboard()
      
        self.hideActivityIndicator(false)
        
        let textFieldText = cityTextfield.text?.trimmingCharacters(in: .whitespaces)
        
        if cityTextfield.text != nil && cityTextfield.text != ""
        {
            Geolocation.shared.getLocation { (lat, long) in
                
                GeolocationInverse.shared.getCoordinateFromCity(cityString: textFieldText!) { (placemarks, error) in
                    
                    GeolocationInverse.shared.getAdressFromCoordinate(latitud: placemarks.latitude, longitud: placemarks.longitude) { completeCloruse in
                        
                        self.currentCityLabel.text = completeCloruse.uppercased()
                    }
                    
                    ConnectionsWrapper.sharedInstance.getUrl(latitud: placemarks.latitude, longitud: placemarks.longitude, delegate: self, completion: {})
                    
                    ConnectionsWrapper.sharedInstance.getUrlForTime(latitud: placemarks.latitude, longitud: placemarks.longitude, delegate: self, completion: {})

                    self.hideActivityIndicator(true)
                }
            }
        }
        else
        {
            print("error")
            let alertController = UIAlertController(title: "Empty Field", message: "You must search a city to get weather", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true)
            self.hideActivityIndicator(true)
        }
        
        //self.hideActivityIndicator(true)
    }
    
    
    func setTime(time: Time) {
        
        self.time = time
        
        let dayNight = Converters.convertDayNight(day: self.time.time)
        
        DispatchQueue.main.async {
            if dayNight == "n"
            {
                if self.weather != nil
                {
                    if self.weather.cloudiness.contains("Cloud")
                    {
                        self.backgroundImage.addBlurEffect()
                        self.backgroundImage.image = UIImage(named: "nightClouds")
                        self.motivationalSentence.text = "Bad weather always looks worse through a window"
                    }
                    else
                    {
                        self.backgroundImage.addBlurEffect()
                        self.backgroundImage.image = UIImage(named: "night")
                        self.motivationalSentence.text = "The weather is fine, and the air is full of the scent of strawberries"
                    }
                }
            }
            else
            {
                if self.weather != nil
                {
                    if self.weather.cloudiness.contains("Cloud")
                    {
                        self.backgroundImage.addBlurEffect()
                        self.backgroundImage.image = UIImage(named: "nublado")
                        self.motivationalSentence.text = "The best thing one can do when it’s raining is to let it rain"
                    }
                    else
                    {
                        self.backgroundImage.addBlurEffect()
                        self.backgroundImage.image = UIImage(named: "sol")
                        self.motivationalSentence.text = "The day was bright and sunny"
                    }
                }
            }


            //Weather icons: clear-night, cloudy-night, cloudy, default, rain-night, rain, snow, sunny

            if self.weather != nil
            {
                if dayNight == "n"
                {
                    if self.weather.cloudiness.contains("Clear")
                    {
                        self.iconImage.image = UIImage(named: "clear-night")
                    }
                    else if self.weather.cloudiness.contains("Cloudy") || self.weather.cloudiness.contains("Overcast")
                    {
                        self.iconImage.image = UIImage(named: "cloudy-night")
                    }
                    else if self.weather.cloudiness.contains("Rain") || self.weather.cloudiness.contains("Showers")
                    {
                        self.iconImage.image = UIImage(named: "rain-night")
                    }
                    else if self.weather.cloudiness.contains("Snow")
                    {
                        self.iconImage.image = UIImage(named: "snow")
                    }
                    else
                    {
                        self.iconImage.image = UIImage(named: "default")
                    }
                }
                else
                {
                    if self.weather.cloudiness.contains("Clear") || self.weather.cloudiness.contains("Sunny")
                    {
                        self.iconImage.image = UIImage(named: "sunny")
                    }
                    else if self.weather.cloudiness.contains("Cloudy") || self.weather.cloudiness.contains("Overcast")
                    {
                        self.iconImage.image = UIImage(named: "cloudy")
                    }
                    else if self.weather.cloudiness.contains("Rain") || self.weather.cloudiness.contains("Showers")
                    {
                        self.iconImage.image = UIImage(named: "rain")
                    }
                    else if self.weather.cloudiness.contains("Snow")
                    {
                        self.iconImage.image = UIImage(named: "snow")
                    }
                    else
                    {
                        self.iconImage.image = UIImage(named: "default")
                    }
                }
            }
        }
    }

    
    
    func setWeather(weather: Weather)
    {
        self.weather = weather

        let tempCelsius = Converters.convertToCelsius(farenheit: self.weather.temperature)
        let speedKmh = Converters.convertToKmh(speed: Int(self.weather.wind))
        let humidityPercentage = Converters.convertToPercent(humidity: self.weather.humidity)
        let sensationTempCelsius = Converters.convertToCelsius(farenheit: self.weather.sensation)
        
        
        DispatchQueue.main.async {
            
            self.temperatureLabel.text = String(format: "%iºC", tempCelsius)
            print("\(tempCelsius)")
            
            self.windLabel.text = String("\(String(describing: speedKmh))Km/h")
            print("\(String(describing: speedKmh))")
            
            self.humidityLabel.text = String("\(String(describing: humidityPercentage))%")
            print("\(String(describing: humidityPercentage))")
            
            self.cloudinessLabel.text = weather.cloudiness
        
            let textfieldValue = self.cityTextfield.text?.capitalized
            NSUserDefaultManager.sharedInstance.persistData(textfield: textfieldValue!, key: "city")
            
            self.localTime.text = "Timezone: \(self.weather.timeZone)"
            
            self.sensationTemperature.text = String(format: "%iºC", sensationTempCelsius)
            print("\(sensationTempCelsius)")
            
            self.UVIndexLabel.text = String(self.weather.UVIndex)
            
            self.visibilityLabel.text = String("\(self.weather.visibility) Miles")
        }
    }
}
