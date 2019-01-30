//
//  Geolocation.swift
//  PlantilaProyecto
//
//  Created by Daniel Cano on 27/8/18.
//  Copyright © 2018 Daniel Cano. All rights reserved.
//

import UIKit
import CoreLocation

class Geolocation: NSObject, CLLocationManagerDelegate { //ajusto mi clase a los protocolos que quiero

    var locationManager = CLLocationManager()
    var lat: Double = 0.0
    var long: Double = 0.0
    
    var datosLoc: ((Double, Double) -> Void)? = nil
    
    
    func getLocation(callback: @escaping (Double, Double) -> Void) {
        
        locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest //hay muchas, la mejor es la de navigation
        self.locationManager.requestLocation()
        datosLoc = callback
    }

    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        let alertView = UIAlertController(title: "Error", message: "No ha sido posible encontrar su situación", preferredStyle: .alert)
        let alertButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertView.addAction(alertButton)
        
        
        let autorizacion = CLLocationManager.authorizationStatus()
        switch autorizacion {
            
        case .denied, .notDetermined, .restricted:
        
            UIApplication.shared.keyWindow?.rootViewController?.present(alertView, animated: true, completion: nil)
        default:
            break
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let localizationValue: CLLocationCoordinate2D = (manager.location?.coordinate)!
        
        
        if datosLoc != nil
        {
            datosLoc!(localizationValue.latitude, localizationValue.longitude)
        }
        
        locationManager.stopUpdatingLocation()        
    }
    

    static let shared: Geolocation = {
        let instance = Geolocation()
        return instance
    }()
}

