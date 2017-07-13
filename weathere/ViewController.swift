//
//  ViewController.swift
//  weathere
//
//  Created by Андрей Илалов on 03.07.17.
//  Copyright © 2017 Андрей Илалов. All rights reserved.
//

import UIKit
//import Alamofire
import Alamofire
import GooglePlaces
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!

    
    

    
    
    @IBOutlet weak var poiDescriptionView: UITextView!


    
    @IBOutlet weak var internalBrowser: UIWebView!
    
    var lat: CLLocationDegrees!
    var long: CLLocationDegrees!
    var theNameOfOrganisation: String!
    
    //let sViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mapViewController") as! MapViewController
    
    var manager:CLLocationManager!
    //nameOfPOI: String
    func showWikiInInternalView (defaultURL: String){
        let request = NSURLRequest(url: NSURL(string: defaultURL)! as URL) as URLRequest
        
        internalBrowser.loadRequest(request)
    }
    
    func getWikiForThePlace(nameOfPOI: String) -> Bool {
        var isOk: Bool = true
        let escapedAddress = NSString(format: "https://ru.wikipedia.org/w/api.php?action=opensearch&search="+nameOfPOI+"+&format=json" as NSString).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        print(escapedAddress!)

        
        
        
        Alamofire.request(escapedAddress!).validate().responseJSON{
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if (String(describing: json[3][0]) != "null"){
                    //isOk = true
                    self.poiDescriptionView.text = String(describing: json[2][0])
                    self.showWikiInInternalView(defaultURL: String(describing: json[3][0]))
                    print("JSON: \(json[3][0])")
                    
                }
                
            case .failure(let error):
            print(error)
                
            }
            
            


             }
        return isOk
    }
    

    @IBOutlet weak var mapButton: UIButton!
    
    @IBAction func mapButtonOn(_ sender: Any) {
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
                    print(self.getWikiForThePlace(nameOfPOI: place.name))
                    if place.rating > 1.0 && String(describing: place.website) != ""  && place.name != nil && self.getWikiForThePlace(nameOfPOI: place.name){
                    print(place.name)
                    self.lat = place.coordinate.latitude
                    self.long = place.coordinate.longitude
                    self.theNameOfOrganisation = place.name
                    print("              fdgssdfgdsfgsdfgsfdgdfgsdfgsdfgsfgsfdg  "+place.name)
                        self.textLabel.text = place.name
//                    self.sViewController.long = place.coordinate.longitude
//                    self.sViewController.lat = place.coordinate.latitude
//                    self.sViewController.theNameOfOrganisation = place.name
                    
                    }
                    print(place.coordinate.latitude)

                }
            }
        })
        
        
        
    
    }
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manager = CLLocationManager()
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
       // print(manager.location?.coordinate.latitude)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "showMap":
            guard let mapDetailViewController = segue.destination as? MapViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            mapDetailViewController.lat = lat
            mapDetailViewController.long = long
            mapDetailViewController.theNameOfOrganisation = theNameOfOrganisation
            print(mapDetailViewController.long)
        default:
            print("")

            
        }}
    

}


//extension ViewController: GMSAutocompleteViewControllerDelegate {
//    
//    // Handle the user's selection.
//    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        print("Place name: \(place.name)")
//        print("Place address: \(place.formattedAddress)")
//        print("Place attributions: \(place.attributions)")
//        dismiss(animated: true, completion: nil)
//    }
//    
//    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
//        // TODO: handle the error.
//        print("Error: \(error)")
//        dismiss(animated: true, completion: nil)
//    }
//    
//    // User cancelled the operation.
//    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
//        print("Autocomplete was cancelled.")
//        dismiss(animated: true, completion: nil)
//    }
//}

