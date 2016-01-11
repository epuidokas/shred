//
//  LocationDataManager.swift
//  Shred the Gnar
//
//  Created by Eric Puidokas on 1/8/16.
//  Copyright © 2016 Eric Puidokas. All rights reserved.
//

import Foundation
import CoreLocation

class LocationDataManager: NSObject, CLLocationManagerDelegate {
    
    static let instance = LocationDataManager()

    var locationManager: CLLocationManager!
    
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    var locationStatus : NSString = "Not Started"

    var locationUpdateDelegates : [LocationDataDelegate]

    override init() {
        locationUpdateDelegates = [LocationDataDelegate]()
        locationManager = CLLocationManager()
        super.init()
        
    }

    func startTracking() {
        
        seenError = false
        locationFixAchieved = false
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.activityType = CLActivityType.OtherNavigation
        
        locationManager.requestAlwaysAuthorization()

    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        locationManager.stopUpdatingLocation()
        if (seenError == false) {
            seenError = true
            print(error)
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        for (index, value) in locationUpdateDelegates.enumerate() {
            value.didUpdateLocations?(locations)
        }

    }

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        var shouldIAllow = false

        switch status {
        case CLAuthorizationStatus.Restricted:
            locationStatus = "Restricted Access to location"
        case CLAuthorizationStatus.Denied:
            locationStatus = "User denied access to location"
        case CLAuthorizationStatus.NotDetermined:
            locationStatus = "Status not determined"
        default:
            locationStatus = "Allowed to location Access"
            shouldIAllow = true
        }
        NSNotificationCenter.defaultCenter().postNotificationName("LabelHasbeenUpdated", object: nil)
        if (shouldIAllow == true) {
            NSLog("Location to Allowed")
            // Start location services
            locationManager.startUpdatingLocation()
        } else {
            NSLog("Denied access: \(locationStatus)")
        }
    }

    func registerDelegate(delegate: LocationDataDelegate) {
        for (var i=0; i<locationUpdateDelegates.count; ++i) {
            if locationUpdateDelegates[i].isEqual(delegate) {
                return;
            }
        }
        locationUpdateDelegates.append(delegate)
        
        if (locationUpdateDelegates.count > 0)
        {
            locationManager.startUpdatingLocation()
            NSLog("Started updating location")
        }
    }

    func unregisterDelegate(delegate: LocationDataDelegate) {
        for (var i=0; i<locationUpdateDelegates.count; ++i) {
            if locationUpdateDelegates[i].isEqual(delegate) {
                locationUpdateDelegates.removeAtIndex(i)
                break;
            }
        }
        
        
        if (locationUpdateDelegates.count == 0)
        {
            locationManager.stopUpdatingLocation()
            NSLog("Stopped updating location")
        }
    }
}