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
    
    @IBOutlet weak var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.addTarget(self, action: "sendFileToMail", forControlEvents: .TouchUpInside)
        
        
        //let locations: NSMutableArray = LocationDatabase.instance.getLocationsForTripId(1)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func sendFileToMail() {
        print("button pushed")
    }

}

