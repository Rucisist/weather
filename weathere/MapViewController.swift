//
//  MapViewController.swift
//  weathere
//
//  Created by Андрей Илалов on 06.07.17.
//  Copyright © 2017 Андрей Илалов. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift
import AVFoundation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate  {
    @IBOutlet weak var textField: UITextView!

    
    let synthesizer : AVSpeechSynthesizer = AVSpeechSynthesizer()
    var utterance : AVSpeechUtterance = AVSpeechUtterance(string: "")
    
    override func viewDidAppear(_ animated: Bool) {
        //try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .interruptSpokenAudioAndMixWithOthers)
        // utterance.voice = AVSpeechSynthesisVoice(identifier: "en-GB")
        //synthesizer.pauseSpeaking(at: .word)
    }
    
        
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func speakk(_ sender: Any) {
        
        UserDefaults.standard.set(["ru"], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        
        
        let detailsData = self.manager1.loadDB(POIName: self.theNameOfOrganisation)
        print("dfsdfsdggdsfgfd"+String(describing:  detailsData[0].tempList[0].wikiSite))
        
        utterance = AVSpeechUtterance(string: String(describing:  detailsData[0].tempList[0].wikiDescription) )
        //speak1()
       
        
        //synthesizer.pauseSpeaking(at: .word)
        if synthesizer.isPaused{
            //synthesizer.speak(utterance)
            synthesizer.continueSpeaking()
            //print()
            return
        }
        if synthesizer.isSpeaking {
            synthesizer.pauseSpeaking(at: .word)
            return
        }
        else{
            synthesizer.speak(utterance)
            synthesizer.continueSpeaking()
            return
        }

    }
    

    
    
    var locationManager: CLLocationManager!
    var long: CLLocationDegrees!
    var lat: CLLocationDegrees!
    var theNameOfOrganisation: String!
    var URL1: String!
    var URL2: String!
    let manager1 = DataMan()

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        renderer.alpha=0.4
        
        return renderer
    }
    
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        print(URL1)
        textField.text = URL1
   
        
        
        
        self.mapView.delegate = self
        //self.mapView.mapType = MKMapType.satellite
        self.mapView.showsUserLocation = true
        // Do any additional setup after loading the view.
//        var kx : Double
//        var ky : Double
        
     //   let regionRadius: CLLocationDistance = 100
        
        var cord = CLLocationCoordinate2D()
        
        cord.latitude = lat!
        cord.longitude = long!
        print(cord.longitude)
        
        
        
        if (lat != nil && long != nil && theNameOfOrganisation != nil){
        
        let destinationLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        // 3.
        let sourcePlacemark = MKPlacemark(coordinate: (locationManager.location?.coordinate)!, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        // 4.
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // 5.
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Ваше положение"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = theNameOfOrganisation
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        // 6.
        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        // 7.
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .walking
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        // 8.
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            
            
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            
            
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        
            
            
//        let thePlacemark = MKPlacemark(coordinate: cord, addressDictionary: nil)
//        
//        let theMapItem = MKMapItem(placemark: thePlacemark)
//        
//        let theAnnotation = MKPointAnnotation()
//        
//        theAnnotation.title = theNameOfOrganisation
//        
//        self.mapView.showAnnotations([theAnnotation,theAnnotation], animated: true)
//        
//        let coordinateRegion = MKCoordinateRegionMakeWithDistance((locationManager.location?.coordinate)!,
//                                                                  regionRadius * 2.0, regionRadius * 2.0)
//        self.mapView.setRegion(coordinateRegion, animated: true)
        
            }}
        
        
        let detailsData = self.manager1.loadDB(POIName: self.theNameOfOrganisation)
        print("dfsdfsdggdsfgfd"+String(describing:  detailsData[0].POI_name))
        

        //print()


    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "showWeb1":
            guard let webDetailViewController = segue.destination as? WebViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            var defurl = URL2!
            print(defurl)
           
                
                let request1 = NSURLRequest(url: NSURL(string: defurl)! as URL) as URLRequest
                
                
                webDetailViewController.request = request1 as NSURLRequest
               // webDetailViewController.webView1.loadRequest(request1)
            

            
            
                default:
            print("")
            
            
        }}


    override func viewWillDisappear(_ animated: Bool) {
        synthesizer.stopSpeaking(at: .immediate)
        
        
        
    }
    /*
    // MARK: - Navigation

     
     
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
