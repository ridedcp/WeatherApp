//
//  NSUserDefaultManager.swift
//  ElTiempoApp
//
//  Created by Daniel Cano on 6/9/18.
//  Copyright © 2018 Daniel Cano. All rights reserved.
//

import UIKit

class NSUserDefaultManager{
    
    //MARK: - EXIST KEY
    func existKeyInUserDefaults(key: String) -> Bool{
        
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    //MARK: - DELETE VALUES IN DEFAULTS
    func deleteValueInUserDefaultsWith(key: String){
        
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    func deleteAllValuesInUserDefaults(){
        
        if let bundle = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundle)
        }
    }
    
    //PERSIST DATA
    func persistData(textfield: String, key: String)
    {
        UserDefaults.standard.set(textfield, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func persistDataWithoutTextfield(data: Any, key: String)
    {
        UserDefaults.standard.set(data, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    
    //RECOVER OBJECT WITH A KEY
    func recoverData(key: String) -> String
    {
        var dato: String = ""
        
        if let string = UserDefaults.standard.value(forKey: key) as? String
        {
            dato = string
        }
        
        return dato
    } 
    
    
    //MARK: - SINGLETON
    static let sharedInstance: NSUserDefaultManager = {
        
        let instance = NSUserDefaultManager()
        return instance
    }()
    
}
