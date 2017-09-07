//
//  ViewController.swift
//  Notes
//
//  Created by Moataz on 8/27/17.
//  Copyright © 2017 Moataz. All rights reserved.
//

import UIKit
import  FirebaseDatabase
import FirebaseAuth
import MapKit
import CoreLocation
import GoogleMaps
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {

    
    var handle:DatabaseHandle?
    var ref:DatabaseReference?
    var myNotes:[String] = []
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var myText: UITextField!
    @IBOutlet weak var myTV: UITableView!
    let locationManager   = CLLocationManager()
   
    @IBAction func LOGOUT(_ sender: Any) {
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "LOsegue", sender: self)
    }
    
   	@IBAction func LocationBtn(_ sender: Any) {
        myTV.delegate = self
        myTV.dataSource = self
        ref = Database.database().reference()
        handle = ref?.child("list").observe(.childAdded, with: {(snapshot)in
            if let value = snapshot.value as? NSDictionary{
                let longt = value["Longitude"] as? String ?? ""
                let latd = value["Latitude"] as? String ?? ""
                let x = Double(longt)
                let y = Double (latd)
                
                self.map.delegate = self as? MKMapViewDelegate
                
                let usrLocation = CLLocationCoordinate2DMake(x!, y!)
                // Drop a pin
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = usrLocation
                dropPin.title = "User Location"
                self.map.addAnnotation(dropPin)
            }
        })
    }
    
    //Add Button
    @IBAction func btnSave(_ sender: Any)
    {
        
        if myText.text != ""
        {
            //self.ref?.child("list").child("text").setValue(self.myText.text )
            
            let lat: Double = (locationManager.location?.coordinate.latitude)!
            let lon: Double = (locationManager.location?.coordinate.longitude)!
            self.ref?.child("list").childByAutoId().setValue(["Text": self.myText.text as Any,"Latitude": lat, "Longitude": lon])
            
            myText.text = ""
           }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
       //FirebaseRetrieve
        myTV.delegate = self
        myTV.dataSource = self
        ref = Database.database().reference()
        handle = ref?.child("list").observe(.childAdded, with: {(snapshot)in
            if let value = snapshot.value as? NSDictionary{
            let item = value["Text"] as? String ?? ""

                self.myNotes.append(item)
                self.myTV.reloadData()
                
                
            }
        })
    /*   //Swipe
        let recognizer = UITapGestureRecognizer(target: self, action: Selector(("didTabbed")))
        self.myTV.addGestureRecognizer(recognizer)*/
        
    }
   /* //SwipeFunction
    func didTabbed(recognizer: UIGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.ended {
            let tabLocation = recognizer.location(in: self.myTV)
            if let swipedIndexPath = myTV.indexPathForRow(at: tabLocation) {
                if self.myTV.cellForRow(at: swipedIndexPath) != nil {
                    // Swipe happened. Do stuff!
                    myTV.delegate = self
                    myTV.dataSource = self
                    ref = Database.database().reference()
                    handle = ref?.child("list").observe(.childAdded, with: {(snapshot)in
                        if let value = snapshot.value as? NSDictionary{
                            let longt = value["Longitude"] as? String ?? ""
                            let latd = value["Latitude"] as? String ?? ""
                            let x = Double(longt)
                            let y = Double (latd)
                            
                            self.map.delegate = self as? MKMapViewDelegate
                            
                            let usrLocation = CLLocationCoordinate2DMake(x!, y!)
                            // Drop a pin
                            let dropPin = MKPointAnnotation()
                            dropPin.coordinate = usrLocation
                            dropPin.title = "User Location"
                            self.map.addAnnotation(dropPin)
                        }
                    })
                }
    }
        }}*/
    //Setting up our TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myNotes.count
    }
    var myIndex = 0
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        myTV.delegate = self
        myTV.dataSource = self
        ref = Database.database().reference()
         handle = ref?.child("list").observe(.childAdded, with: {(snapshot)in
            if let value = snapshot.value as? NSDictionary{
                let longt = value["Longitude"] as? Double //?? ""
                let latd = value["Latitude"] as? Double //?? ""
                //let x = Double(longt)
                //let y = Double (latd)
                self.map.delegate = self as? MKMapViewDelegate
                let usrLocation = CLLocationCoordinate2DMake(latd!, longt!)
                // Drop a pin
                let annotationsToRemove = self.map.annotations.filter { $0 !== self.map.userLocation }
                self.map.removeAnnotations( annotationsToRemove )
                
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = usrLocation
                dropPin.title = "User Location"
                self.map.addAnnotation(dropPin)
            }
        })
}
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = (myNotes[indexPath.row])
        return cell
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   /* func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Get first location item returned from locations array
        let userLocation = locations[0]
        
        // Convert location into object with human readable address components
        CLGeocoder().reverseGeocodeLocation(userLocation) { (placemarks, error) in
            
            // Check for errors
            if error != nil {
                
                print(error ?? "Unknown Error")
                
            } else {
                
                // Get the first placemark from the placemarks array.
                // This is your address object
                if let placemark = placemarks?[0] {
                    
                    // Create an empty string for street address
                    var streetAddress = ""
                    
                    // Check that values aren't nil, then add them to empty string
                    // "subThoroughfare" is building number, "thoroughfare" is street
                    if placemark.subThoroughfare != nil && placemark.thoroughfare != nil {
                        
                        streetAddress = placemark.subThoroughfare! + " " + placemark.thoroughfare!
                        
                    } else {
                        
                        print("Unable to find street address")
                        
                    }
                    
                    // Same as above, but for city
                    var city = ""
                    
                    // locality gives you the city name
                    if placemark.locality != nil  {
                        
                        city = placemark.locality!
                        
                    } else {
                        
                        print("Unable to find city")
                        
                    }
                    
                    // Do the same for state
                    var state = ""
                    
                    // administrativeArea gives you the state
                    if placemark.administrativeArea != nil  {
                        
                        state = placemark.administrativeArea!
                        
                    } else {
                        
                        print("Unable to find state")
                        
                    }
                    
                    // And finally the postal code (zip code)
                    var zip = ""
                    
                    if placemark.postalCode != nil {
                        
                        zip = placemark.postalCode!
                        
                    } else {
                        
                        print("Unable to find zip")
                        
                    }
                    
                    print("\(streetAddress)\n\(city), \(state) \(zip)")
                    
                }
                
            }
            
        }
        let coordinate = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,
                                                longitude: userLocation.coordinate.longitude)
        
        // Set the span (zoom) of the map view. Smaller number zooms in closer
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        
        // Set the region, using your coordinates & span objects
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        // Set your map object's region to the region you just defined
        map.setRegion(region, animated: true)
        
    }*/
    /*//STack func
     func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
     print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
     let alertController = UIAlertController(title: "Crea Marker", message: "...", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
     let DestructiveAction = UIAlertAction(title: "Annulla", style: UIAlertActionStyle.cancel) {
     (result : UIAlertAction) -> Void in
     print("Annulla")
     }
     
     // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
     let okAction = UIAlertAction(title: "Crea", style: UIAlertActionStyle.default) {
     (result : UIAlertAction) -> Void in
     let ref = Database.database().reference().child("userdata")
     let post = ["latitude": coordinate.latitude,"longitude": coordinate.longitude]
     ref.childByAutoId().setValue(post)
     
     print("Entra")
     }
     
     alertController.addAction(DestructiveAction)
     alertController.addAction(okAction)
     self.present(alertController, animated: true, completion: nil)
     }*/

    /* //LocationButton
     self.ref = Database.database().reference().child("list")
     ref?.observe(.childAdded, with: { (snapshot) in
     self.ref?.observe(DataEventType.value, with: { (snapshot) in
     if (snapshot.value as? [String:Any]) != nil {
     for rest in snapshot.children.allObjects as! [DataSnapshot] {
     guard let Dict = rest.value as? [String: AnyObject] else {
     continue
     }
     let latitude = Dict["latitude"]
     let longitude = Dict["longitude"]
     let marker = GMSMarker()
     marker.position = CLLocationCoordinate2D(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
     }
     }
     })
     })*/
    
}

