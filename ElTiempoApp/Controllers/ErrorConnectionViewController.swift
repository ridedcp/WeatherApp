//
//  ErrorConnectionViewController.swift
//  ElTiempoApp
//
//  Created by Daniel Cano on 28/09/2018.
//  Copyright © 2018 Daniel Cano. All rights reserved.
//

import UIKit

class ErrorConnectionViewController: UIViewController {

    @IBOutlet weak var tryAgainButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tryAgainButtonOutlet.personalizedButtons()
    }
    

    
    @IBAction func tryAgainButton(_ sender: Any)
    {
        let internet = Reachability()
    
        if internet.isInternetAvailable()
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as UIViewController
            present(vc, animated: true, completion: nil)
        }
    }
    
}
