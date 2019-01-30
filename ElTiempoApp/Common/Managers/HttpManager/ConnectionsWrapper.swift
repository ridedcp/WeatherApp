//
//  ConnectionsWrapper.swift
//  PlantillaProyectosDani
//
//  Created by Daniel Cano on 30/8/18.
//  Copyright © 2018 Daniel Cano. All rights reserved.
//

import UIKit
import SwiftyJSON


protocol MeteoData {
    func setWeather(weather: Weather)
    func setTime(time: Time)
}

enum errors: Error
{
    case communicationError(msg: String)
    case unexpectedError(msg: String)
}


class ConnectionsWrapper: NSObject {
    
    
    func getUrl(latitud: Double, longitud: Double, delegate: MeteoData, completion: @escaping () -> Void)
    {
        let apiURL: NSURL = NSURL(string: "\(Constants.ConexionesTiempoForecast.forecastURL)" + "\(Constants.ConexionesTiempoForecast.forecastKey)" + "\(latitud),\(longitud)")!
            
            //Forma para acceder a la url a traves de URLSession
            let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: apiURL as URL)
            let session = URLSession.shared
            let task = session.dataTask(with: urlRequest as URLRequest) { (data, response, error) -> Void in
                
                //IMPLEMENTACIÓN DE LA CLOSURE
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                if (statusCode == 200)
                {
                    do
                    {
                        if let unwrappedData = data
                        {
                            //PASO LOS DATOS A JSON
                            let json = JSON(unwrappedData)
                            
                            let temperature = json["currently"]["temperature"].int ?? 0
                            let cloudiness = json["currently"]["summary"].string ?? "No JSON Data"
                            let wind = json["currently"]["windSpeed"].double ?? 0.0
                            let humidity = json["currently"]["humidity"].double ?? 0.0
                            let icon = json["currently"]["icon"].string ?? "No icon"
                            //let time = json["currently"]["time"].double ?? 12.0
                            let timeZone = json["timezone"].string ?? "No timezone"
                            let sensations = json["currently"]["apparentTemperature"].int ?? 0
                            let UVIndex = json["currently"]["uvIndex"].int ?? 0
                            let visibility = json["currently"]["visibility"].float ?? 0.0
                            
                            let myWeather = Weather(temperature: temperature, cloudiness: cloudiness, wind: wind, humidity: humidity, icon: icon, timeZone: timeZone, sensation: sensations, UVIndex: UVIndex, visibility: visibility)
                            
                            delegate.setWeather(weather: myWeather)
                            completion()
                        }
                        else
                        {
                            throw errors.communicationError(msg: Constants.Errors.dataError)
                        }
                    }
                    catch
                    {
                        print("\(Constants.Errors.unexpectedError)")
                    }
                }
            }
            
            task.resume()
        }
    
    
    func getUrlForTime(latitud: Double, longitud: Double, delegate: MeteoData, completion: @escaping () -> Void)
    {
        let timeZoneApiURL: NSURL = NSURL(string: "\(Constants.ConexionesZonaHoraria.timeZoneApiURL)" + "lat=\(latitud)&lon=\(longitud)" + "\(Constants.ConexionesZonaHoraria.timeZoneApiKey)")!
        
        //Forma para acceder a la url a traves de URLSession
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: timeZoneApiURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) { (data, response, error) -> Void in
            
            //IMPLEMENTACIÓN DE LA CLOSURE
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200)
            {
                do
                {
                    if let unwrappedData = data
                    {
                        //PASO LOS DATOS A JSON
                        let json = JSON(unwrappedData)
                        
                        if let date = json["data"].array {
                            
                            for time in date {

                                let tiempoGuardado: String = time["pod"].string ?? "arriquitaun"
                                print("Day or Night: \(time["pod"])")
                                
                                //Me devuelve una "d" (day) o una "n" (night)
                                
                                let myTime = Time(time: tiempoGuardado)                                
                                delegate.setTime(time: myTime)
                            }
                        }
                        
                        completion()
                    }
                    else
                    {
                        throw errors.communicationError(msg: Constants.Errors.dataError)
                    }
                }
                catch
                {
                    print("\(Constants.Errors.unexpectedError)")
                }
            }
        }
        
        task.resume()
    }
    
    
    
    

    //MARK: SINGLETON
    static  let sharedInstance: ConnectionsWrapper = {
        let instance = ConnectionsWrapper()
        return instance
    }()
}

