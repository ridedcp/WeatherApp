//
//  Converters.swift
//  ElTiempoApp
//
//  Created by Dani on 16/9/18.
//  Copyright © 2018 Daniel Cano. All rights reserved.
//

import Foundation

class Converters: NSObject {
    
    
    //Funcion para hacer la conversión de farenheit a celsius
    class func convertToCelsius(farenheit: Int) -> Int
    {
        return Int(5.0 / 9.0 * (Double(farenheit) - 32.0))
    }
    
    //Funcion para convertir el dato decimal a %
    class func convertToPercent(humidity: Double) -> Int
    {
        return Int(humidity * 100)
    }
    
    //funcion para convertir m/s a k/h
    class func convertToKmh(speed: Int) -> Int
    {
        return speed * 3600 / 1000
    }
    
    //convierto n en night y d en day
    class func convertDayNight(day: String) -> String
    {
        return day
    }
}
