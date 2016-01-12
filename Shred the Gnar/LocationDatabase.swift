//
// Created by Eric Puidokas on 1/11/16.
// Copyright (c) 2016 Eric Puidokas. All rights reserved.
//

import Foundation
import CoreLocation
import FMDB

class LocationDatabase: NSObject, LocationDataDelegate {

    static let instance = LocationDatabase()

    var inBackground : Bool = false

    var locationDataForBackground : [CLLocation]

    override init() {
        locationDataForBackground = [CLLocation]()
        super.init()
    }

    func loadDatabase() {
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)

        let docsDir:String = dirPaths[0]

        
        let databasePath:String = NSURL(fileURLWithPath: docsDir).URLByAppendingPathExtension("data.db").absoluteString

        
        
        if !filemgr.fileExistsAtPath(databasePath as String) {

            let contactDB = FMDatabase(path: databasePath as String)

            if contactDB == nil {
                println("Error: \(contactDB.lastErrorMessage())")
            }

            if contactDB.open() {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS location_data (id INTEGER PRIMARY KEY AUTOINCREMENT, trip_id INTEGER, timestamp INTEGER, lat REAL, lon REAL, alt REAL, speed REAL, course REAL, h_acc REAL, v_acc REAL )"
                if !contactDB.executeStatements(sql_stmt) {
                    println("Error: \(contactDB.lastErrorMessage())")
                }
                contactDB.close()
            } else {
                println("Error: \(contactDB.lastErrorMessage())")
            }
        }
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

        location.
        var lat = String(format:"%f", location.coordinate.latitude)
        var lon = String(format:"%f", location.coordinate.longitude)
        print("\nlat:" + lat + ", lon:" + lon)
    }
}
