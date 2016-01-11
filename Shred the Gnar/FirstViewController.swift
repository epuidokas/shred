//
//  FirstViewController.swift
//  Shred the Gnar
//
//  Created by Eric Puidokas on 1/8/16.
//  Copyright © 2016 Eric Puidokas. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class FirstViewController: UIViewController, LocationDataDelegate {
    
    @IBOutlet weak var textbox: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        mapView.mapType = MKMapType.Satellite
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()


    }
    
    override func viewDidAppear(animated: Bool) {
        
        print("opening")

        LocationDataManager.instance.registerDelegate(self)
        LocationDataManager.instance.startTracking()
    }
    
    override func viewWillDisappear(animated: Bool) {

        LocationDataManager.instance.unregisterDelegate(self)
        print("closing")
        
    }

    func didUpdateLocations( locations: [CLLocation]) {
        var locationArray = locations as NSArray
        var locationObj = locationArray.lastObject as! CLLocation
        var coord = locationObj.coordinate
        
        if (textbox != nil) {
            
            var string = textbox.text as String!
            
            var lat = String(format:"%f", coord.latitude)
            var lon = String(format:"%f", coord.longitude)
            
            string = string + "\nlat:" + lat + ", lon:" + lon

            textbox.text = string
        }
        
    }

}

