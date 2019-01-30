//
//  Weather.swift
//  ElTiempoApp
//
//  Created by Daniel Cano on 3/9/18.
//  Copyright © 2018 Daniel Cano. All rights reserved.
//

import Foundation

class Weather: NSObject {
    
    var temperature: Int
    var cloudiness: String
    var wind: Double
    var humidity: Double
    var icon: String
    var timeZone: String
    var sensation: Int
    var UVIndex: Int
    var visibility: Float

    
    init(temperature: Int, cloudiness: String, wind: Double, humidity: Double, icon: String, timeZone: String, sensation: Int, UVIndex: Int, visibility: Float)
    {
        self.temperature = temperature
        self.cloudiness = cloudiness
        self.wind = wind
        self.humidity = humidity
        self.icon = icon
        self.timeZone = timeZone
        self.sensation = sensation
        self.UVIndex = UVIndex
        self.visibility = visibility
    }
    
}
