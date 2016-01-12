//
//  SecondViewController.swift
//  Shred the Gnar
//
//  Created by Eric Puidokas on 1/8/16.
//  Copyright © 2016 Eric Puidokas. All rights reserved.
//

import UIKit
import CoreLocation

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let locations: NSMutableArray = LocationDatabase.instance.getLocationsForTripId(1)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

