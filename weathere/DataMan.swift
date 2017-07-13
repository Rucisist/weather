//
//  DataMan.swift
//  weathere
//
//  Created by Андрей Илалов on 13.07.17.
//  Copyright © 2017 Андрей Илалов. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift


class DataMan {
    
    
    
    
    
func getWikiForThePlace(nameOfPOI: String){
    
        let realm = try! Realm()
    
        let escapedAddress = NSString(format: "https://ru.wikipedia.org/w/api.php?action=opensearch&search="+nameOfPOI+"+&format=json" as NSString).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)

    
        Alamofire.request(escapedAddress!).validate().responseJSON{
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let POI1 = POIData()
                
                    print(json[2][0].stringValue)
                    let tmp = Temp()
                    tmp.wikiDescription =  json[2][0].stringValue
//                    tmp.icon = subJson["weather"][0]["icon"].stringValue
//                    tmp.date = subJson["dt_txt"].stringValue
                    POI1.tempList.append(tmp)
                
                
                
                if (json[3][0].stringValue != nil){
                    POI1.POI_name = "fdgdfg"//json[3][0].stringValue
                    //print("jd")
                    }
                else {
                    POI1.POI_name = "he"
                }                
                try! realm.write {
                    realm.add(POI1, update: true)
                }
                
                

                
            case .failure(let error):
                print(error)
            }
    }
    
    
    
    
}
    
    
    func loadDB(POIName: String) -> Results<POIData>  {
        let realm = try! Realm()
        let data = realm.objects(POIData.self).filter("POI_name BEGINSWITH %@", POIName)
        
        return data
    }

    
    
    func loadPOIListDB() -> [String]  {
        let realm = try! Realm()
        var POIlist: [String] = []
        let data = realm.objects(POIData.self)
        
        for value in data {
            POIlist.append(value.POI_name)
        }
        
        return POIlist
    }
    
    

    
    
}
