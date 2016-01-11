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

    override func viewWillAppear(animated: Bool) {
        loadLocation()
    }

    override func viewDidAppear(animated: Bool) {
        LocationDataManager.instance.registerDelegate(self)
        LocationDataManager.instance.startTracking()
        loadLocation()
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSLog("Heading: " + String(mapView.camera.heading))
        NSLog("Pitch: " + String(mapView.camera.pitch))
        NSLog("Distance: " + String(mapView.camera.altitude))
        NSLog("Center: " + String(mapView.camera.centerCoordinate.latitude) + "," + String(mapView.camera.centerCoordinate.longitude))
        
        LocationDataManager.instance.unregisterDelegate(self)
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

    func loadLocation() {
        
        // Hardcoded to Okemo
        
        var center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 43.4097813313175, longitude: -72.7328804582154)
        var distance: CLLocationDistance = CLLocationDistance(11640.3639390641)
        var pitch: CGFloat = 0.0;
        var heading: CLLocationDirection = 280.484390097839;
        

        //mapView.setRegion(region, animated: false)

        //var camea: MKMapCamera = MKMapCamera(lookingAtCenterCoordinate: locationTo, fromEyeCoordinate: locationFrom, eyeAltitude: distance)
        //
        var camea: MKMapCamera = MKMapCamera(lookingAtCenterCoordinate: center, fromDistance: distance, pitch: pitch, heading: heading)

        mapView.setCamera(camea, animated: false)
        
    }

}

