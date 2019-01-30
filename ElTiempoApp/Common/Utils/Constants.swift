//
//  Constants.swift
//  PlantillaProyectosDani
//
//  Created by Daniel Cano on 30/8/18.
//  Copyright © 2018 Daniel Cano. All rights reserved.
//

import UIKit

struct Constants {
    
    static let APP_NAME = "World Weather App"
    
    
    //MARK: -  IDENTIFIERS
    
    struct Identifiers {
        
        static let homeView = "homeView"
        static let loginView = "loginView"
        static let rememberView = "rememberView"
        
    }
    
    //MARK: -  COLORS
    
    struct Color {
        
        static let toastColor = UIColor(hexString: "#485864")
        static let colorDisableButton = UIColor(hexString: "#ebebeb")
        static let yellowColor = UIColor(hexString: "#eac117")
    }
    
    
    //MARK: -  CONNECTIONS
    struct ConexionesTiempoForecast {
        static let forecastURL = "https://api.forecast.io/forecast/"
        static let forecastKey = "c19ba2cf80f2e4ebf2f29d4eebc4260a/"
    }
    
    struct ConexionesZonaHoraria {
        static let timeZoneApiURL = "https://api.weatherbit.io/v2.0/current?" //lat=41.390205&lon=2.154007"
        static let timeZoneApiKey = "&key=4054ce6678f749ff8216170201f0670d"

    }
    
    
    struct Errors {
        static let jsonError = "JSON Error"
        static let dataError = "Data Error"
        static let unexpectedError = "Unexpected Error"
    }
    
}
