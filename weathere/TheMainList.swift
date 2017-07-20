//
//  TheMainList.swift
//  weathere
//
//  Created by Андрей Илалов on 10.07.17.
//  Copyright © 2017 Андрей Илалов. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapKit
import GooglePlaces
import RealmSwift

class TheMainList: UITableViewController {

    
    
    
    
    var POIs: [POI] = []
    var lat: CLLocationDegrees!
    var long: CLLocationDegrees!
    var theNameOfOrganisation: String!
    var wikiD: String!
    var wikiS: String!
    var wd: [String] = []
    var ws: [String] = []
    var managerData = DataMan()
    //let sViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mapViewController") as! MapViewController
    
    var manager:CLLocationManager!
    //nameOfPOI: String
//    func showWikiInInternalView (defaultURL: String){
//        let request = NSURLRequest(url: NSURL(string: defaultURL)! as URL) as URLRequest
//        
//       // internalBrowser.loadRequest(request)
//    }
    
    func getWikiForThePlace(nameOfPOI: String) -> Bool {
        var isOk: Bool = true
        let escapedAddress = NSString(format: "https://ru.wikipedia.org/w/api.php?action=opensearch&search="+nameOfPOI+"+&format=json" as NSString).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        //print(escapedAddress!)
        
        
        
        
        Alamofire.request(escapedAddress!).validate().responseJSON{
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("hi\n")
                self.ws.append(String(describing: json[3][0]))
                self.wd.append(String(describing: json[2][0]))
                if (String(describing: json[2][0]) != "null"){
                    isOk = true
                    //self.poiDescriptionView.text = String(describing: json[2][0])
                    //self.showWikiInInternalView(defaultURL: String(describing: json[3][0]))
                    //print("JSON: \(json[3][0])")
                    self.wikiD = String(describing: json[2][0])
                    self.wikiS = String(describing: json[3][0])

                    print("jgkjgjkhgjh"+self.wikiS)
                    print(isOk)
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
                
            }
            
            
            
            
        }
        return isOk
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "i")
        
        //let acController = GMSAutocompleteViewController()
        //acController.delegate = self
        //present(acController, animated: true, completion: nil)
        manager = CLLocationManager()
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        let placesClient = GMSPlacesClient()
        //print(manager.location?.coordinate.latitude)
        
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                for likelihood in placeLikelihoodList.likelihoods {
                    let place = likelihood.place
                    //print(self.getWikiForThePlace(nameOfPOI: place.name))
                    
                    if place.rating > 1.0 && String(describing: place.website) != nil  && place.name != nil {
                        //print(place.name)
                        if self.wikiS == nil {
                            self.wikiS = " "
                        }
                        if self.wikiD == nil{
                            self.wikiD = " "
                        }
                        //print("d"+self.wikiS)
                        self.POIs.append(POI(nameOfPOI: place.name, webOfPOI: String(describing: place.website), ratingOfPOI: place.rating, lattitudeOfPOI: place.coordinate.latitude, longitudeOfPOI: place.coordinate.longitude, wikiDescription: self.wikiD, wikiSite: self.wikiS))
                        
                        
                        self.managerData.getWikiForThePlace(place: place)
                        
                    }

                    self.tableView.reloadData()
                }
            }
        })
//
//        print(self.POIs[0].nameOfPOI)
//        for i in POIs{
//            print(i.nameOfPOI)
//           
//        }
        print(managerData.loadPOIListDB())

        //print(managerData.loadDB(POIName: "https://ru.wikipedia.org/wiki/Apple")[0].tempList[0].wikiDescription)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        


        
        
        
        // #warning Incomplete implementation, return the number of rows
        //print(POIs.count)
        return POIs.count//the number rffrrfft
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TheMainListCell
        cell.cellMon.text = POIs[indexPath.row].nameOfPOI

        // Configure the cell...

        return cell
    }


    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "showMap1":
            guard let mapDetailViewController = segue.destination as? MapViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedLinkCell = sender as? TheMainListCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedLinkCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }

            mapDetailViewController.lat = POIs[indexPath.row].lattitudeOfPOI
            mapDetailViewController.long = POIs[indexPath.row].longitudeOfPOI
            mapDetailViewController.theNameOfOrganisation = POIs[indexPath.row].nameOfPOI
//            mapDetailViewController.URL1 = self.wd[indexPath.row]
//            mapDetailViewController.URL2 = self.ws[indexPath.row]
            //print("the e"+mapDetailViewController.URL1)
            //print("sfsfdsagsdfgdfgggggg" + mapDetailViewController.URL1)
            //print(mapDetailViewController.long)
            for i in self.wd{
                print(i)
            }
            //print(self.wd[0])
              default:
            print("")
            
            
        }}

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
