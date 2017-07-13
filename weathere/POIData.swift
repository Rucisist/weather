//
//  POIData.swift
//  weathere
//
//  Created by Андрей Илалов on 13.07.17.
//  Copyright © 2017 Андрей Илалов. All rights reserved.
//

import Foundation
import RealmSwift

class POIData: Object {
    dynamic var POI_name: String = " "
    var tempList = List<Temp>()
    
    override static func primaryKey() -> String? {
        return "POI_name"
    }

}
