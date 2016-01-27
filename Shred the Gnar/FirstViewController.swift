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

class FirstViewController: UIViewController, LocationDataDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var textbox: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var points = [MKAnnotation]()
    
    let MAX_VISIBLE_POINTS = 200
    
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
        let locationArray = locations as NSArray
        for (_, location) in locationArray.enumerate() {
            
            let locationObj = location as! CLLocation
            let coord = locationObj.coordinate
            
            /*
            if (textbox != nil) {
                
                var string = textbox.text as String!
                
                var lat = String(format:"%f", coord.latitude)
                var lon = String(format:"%f", coord.longitude)
                
                string = string + "\nlat:" + lat + ", lon:" + lon

                textbox.text = string
            }
            */
            
            if (mapView != nil) {
                
                
                mapView.delegate = self
                let point: MKPointAnnotation = MKPointAnnotation.init()
                point.coordinate = coord
                mapView.addAnnotation(point)
                
                
                let count = points.count
                if (count >= MAX_VISIBLE_POINTS) {
                    var annotationsToRemove = [MKAnnotation]()
                    for (var i = 0; i + MAX_VISIBLE_POINTS <= count; i++) {
                        annotationsToRemove.append(points.removeFirst())
                    }
                    mapView.removeAnnotations(annotationsToRemove)
                }
                
                
            }
        }
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        //var id = String(random())
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("foo")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "foo")
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        
        annotationView!.image = UIImage(named: "BlueDot")
        
        points.append(annotation)
        
        return annotationView
        
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
        var camera: MKMapCamera = MKMapCamera(lookingAtCenterCoordinate: center, fromDistance: distance, pitch: pitch, heading: heading)

        mapView.setCamera(camera, animated: false)
        
    }

}

