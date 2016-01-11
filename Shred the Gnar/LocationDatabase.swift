//
// Created by Eric Puidokas on 1/11/16.
// Copyright (c) 2016 Eric Puidokas. All rights reserved.
//

import Foundation
import CoreLocation

class LocationDatabase: NSObject, LocationDataDelegate {

    static let instance = LocationDatabase()

    var inBackground : Bool = false

    var locationDataForBackground : [CLLocation]

    override init() {
        locationDataForBackground = [CLLocation]()
        super.init()
    }

    func setBackgroundMode(isInBackground: Bool) {

        if (self.inBackground && !isInBackground) {
            // write background data to database and clear it out
            print("Saving all background data points to database...")
            for (index, value) in locationDataForBackground.enumerate() {
                saveLocation(value)
            }
            locationDataForBackground.removeAll(keepCapacity: false)
            print("Done.")
        }

        self.inBackground = isInBackground
    }

    func didUpdateLocations( locations: [CLLocation])
    {
        if (self.inBackground) {
            for (index, value) in locations.enumerate() {
                locationDataForBackground.append(value)
                print("location point saved for later")
            }
        }
        else {
            for (index, value) in locations.enumerate() {
                saveLocation(value)
            }
        }
    }

    func saveLocation( location: CLLocation)
    {
        // write locations to SQL database
        var lat = String(format:"%f", location.coordinate.latitude)
        var lon = String(format:"%f", location.coordinate.longitude)
        print("\nlat:" + lat + ", lon:" + lon)
    }
}
