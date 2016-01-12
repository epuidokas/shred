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
    
    var locationDB: FMDatabase?
    
    var databaseIsLoaded: Bool = false

    override init() {
        locationDataForBackground = [CLLocation]()
        super.init()
    }

    func loadDatabase() {
        
        if !databaseIsLoaded {
            
            databaseIsLoaded = true
        
            let filemgr = NSFileManager.defaultManager()
            let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)

            let docsDir:String = dirPaths[0]

            
            let databasePath:String = NSURL(fileURLWithPath: docsDir).absoluteString + "data.db"

            
            
            if !filemgr.fileExistsAtPath(databasePath as String) {

                locationDB = FMDatabase(path: databasePath as String)

                if locationDB == nil {
                    print("Error: locationDB is nil")
                    return
                }
                
                if locationDB!.open() {
                    let sql_stmt = "CREATE TABLE IF NOT EXISTS location_data (id INTEGER PRIMARY KEY AUTOINCREMENT, trip_id INTEGER, timestamp INTEGER, lat REAL, lon REAL, alt REAL, speed REAL, course REAL, h_acc REAL, v_acc REAL )"
                    if !locationDB!.executeStatements(sql_stmt) {
                        print("Error: \(locationDB!.lastErrorMessage())")
                    }
                } else {
                    print("Error: \(locationDB!.lastErrorMessage())")
                }
            }
        }
        
    }

    func setBackgroundMode(isInBackground: Bool) {
        
        loadDatabase()

        if (self.inBackground && !isInBackground) {
            
            locationDB!.open()
            
            // write background data to database and clear it out
            print("Saving all background data points to database...")
            for (index, value) in locationDataForBackground.enumerate() {
                saveLocation(value)
            }
            locationDataForBackground.removeAll(keepCapacity: false)
            print("Done.")
        }
        else if (!self.inBackground && isInBackground) {
            locationDB!.close()
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
        let tripId = 1
        let ts = location.timestamp.timeIntervalSince1970
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        let alt = location.altitude
        let speed = location.speed
        let course = location.course
        let h_acc = location.horizontalAccuracy
        let v_acc = location.verticalAccuracy
        
        let sql_stmt = "INSERT INTO location_data (trip_id, timestamp, lat, lon, alt, speed, course, h_acc, v_acc ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
        
        
        if !locationDB!.executeUpdate(sql_stmt, withArgumentsInArray: [tripId, ts, lat, lon, alt, speed, course, h_acc, v_acc]) {
            print("Error: \(locationDB!.lastErrorMessage())")
        }
        
    }
    
    func getLocationsForTripId(tripId: Int) -> NSMutableArray {
        let resultSet: FMResultSet! = locationDB!.executeQuery("SELECT * FROM location_data WHERE trip_id = ?", withArgumentsInArray: [tripId])
        let locationsForTrip : NSMutableArray = NSMutableArray()
        if (resultSet != nil) {
            while resultSet.next() {
        
                let ts = NSDate(timeIntervalSince1970: resultSet.doubleForColumn("timestamp"))
                let lat = resultSet.doubleForColumn("lat")
                let lon = resultSet.doubleForColumn("lon")
                let alt = resultSet.doubleForColumn("alt")
                let speed = resultSet.doubleForColumn("speed")
                let course = resultSet.doubleForColumn("course")
                let h_acc = resultSet.doubleForColumn("h_acc")
                let v_acc = resultSet.doubleForColumn("v_acc")
                
                let coord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                
                let location: CLLocation = CLLocation(coordinate: coord, altitude: alt, horizontalAccuracy: h_acc, verticalAccuracy: v_acc, course: course, speed: speed, timestamp: ts)
                
                locationsForTrip.addObject(location)
            }
        }
        return locationsForTrip
    }
}
