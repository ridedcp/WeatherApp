//
//  GeolocationInverse.swift
//  PlantilaProyecto
//
//  Created by Daniel Cano on 28/8/18.
//  Copyright © 2018 Daniel Cano. All rights reserved.
//

import UIKit
import CoreLocation

class GeolocationInverse: NSObject {

    var center: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    func getAdressFromCoordinate(latitud: Double, longitud: Double, completeCloruse: @escaping (String) -> Void)
    {
        let geo = CLGeocoder()
        center.latitude = latitud
        center.longitude = longitud
        
        let loc: CLLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
        
        geo.reverseGeocodeLocation(loc, completionHandler: {(placemarks, error) in
            
            if (error != nil)
            {
                print("Hay un error")
            }
            
            var pm = placemarks
            
            if pm != nil
            {
                pm = placemarks! as [CLPlacemark]
            }
            else
            {
                return
            }
            
            var adressString: String = ""
            
            
            if (pm?.count)! > 0
            {
                let placemark = placemarks![0]
            
                if placemark.locality != nil
                {
                    adressString = adressString + placemark.locality!
                }
            }
            
            completeCloruse(adressString)
        })
    }
    
    
    
    func getCoordinateFromCity(cityString: String, completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void)
    {
        let geocoder = CLGeocoder()
    
        geocoder.geocodeAddressString(cityString) { (placemarks, error) in
            
            if error == nil
            {
                if let placemark = placemarks?[0]
                {
                    let location = placemark.location!
                    
                    completionHandler(location.coordinate, nil)
                
                    return
                }
            }
            
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    

    
    static let shared: GeolocationInverse = {
        let instance = GeolocationInverse() //inicializo la clase y la devuelvo la clase inicializada
        return instance
    }()
    
}
