//
//  File.swift
//  weathere
//
//  Created by Андрей Илалов on 10.07.17.
//  Copyright © 2017 Андрей Илалов. All rights reserved.
//

import Foundation
import MapKit

class POI {
    //declaring
    var nameOfPOI: String?
    var webOfPOI: String?
    var ratingOfPOI: Float?
    var longitudeOfPOI: CLLocationDegrees?
    var lattitudeOfPOI: CLLocationDegrees?
    var wikiDescription: String?
    var wikiSite: String?
    //Initialization
    init(nameOfPOI: String, webOfPOI: String, ratingOfPOI: Float, lattitudeOfPOI: CLLocationDegrees, longitudeOfPOI: CLLocationDegrees, wikiDescription: String, wikiSite: String) {
        self.nameOfPOI = nameOfPOI
        self.webOfPOI = webOfPOI
        self.ratingOfPOI = ratingOfPOI
        self.lattitudeOfPOI = lattitudeOfPOI
        self.longitudeOfPOI = longitudeOfPOI
        self.wikiDescription = wikiDescription
        self.wikiSite = wikiSite
    }
}

