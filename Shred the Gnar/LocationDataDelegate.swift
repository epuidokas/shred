//
// Created by Eric Puidokas on 1/8/16.
// Copyright (c) 2016 Eric Puidokas. All rights reserved.
//

import Foundation
import CoreLocation

@objc protocol LocationDataDelegate: NSObjectProtocol {

    optional func didUpdateLocations( locations: [CLLocation])

}