//
//  File.swift
//  weathere
//
//  Created by Андрей Илалов on 13.07.17.
//  Copyright © 2017 Андрей Илалов. All rights reserved.
//

import Foundation
import RealmSwift
import MapKit

class Temp: Object {
    dynamic var nameOfPOI: String = ""
    dynamic var webOfPOI: String = ""
    dynamic var ratingOfPOI: Float = 0.0
    dynamic var longitudeOfPOI = CLLocationDegrees()
    dynamic var lattitudeOfPOI = CLLocationDegrees()
    dynamic var wikiDescription: String = ""
    dynamic var wikiSite: String = ""
    
}
