//
//  Homepage.swift
//  Anihna
//
//  Created by Macbook on 9/18/16.
//  Copyright © 2016 Raihana A. Souleymane. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation


class Homepage: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.view.backgroundColor = UIColor(patternImage: UIImage(named: "chad.png")!)
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "chad.png")
        // you can change the content mode:
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFit

        self.view.insertSubview(backgroundImage, at: 0)
        
       self.locationManager.delegate =  self
       self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
       self.locationManager.requestWhenInUseAuthorization()
       self.locationManager.startUpdatingLocation()
        // show the blue dot at the user Location pin
       self.mapView.showsUserLocation = true
        
        
        
        
        
        
        
//        self.addSubview(imageViewBackground)
//        self.sendSubviewToBack(imageViewBackground)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func getLocationStatus() {
        //let locationManager = CLLocationManager()
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            //mapView.showsUserLocation = true
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func currentLocationClick(_ sender: AnyObject) {
        if let btn = sender as? UIButton{
            let authStatus = CLLocationManager.authorizationStatus()
            if(!CLLocationManager.locationServicesEnabled() || (authStatus != CLAuthorizationStatus.authorizedAlways && authStatus != CLAuthorizationStatus.authorizedWhenInUse)) {
                let noLocationServicesAlert = UIAlertController(title: "Location Services Disabled", message: "Enable Location Services to use this feature", preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                noLocationServicesAlert.addAction(ok)
                self.present(noLocationServicesAlert, animated: true, completion: nil)
            }
            else {
                btn.isSelected = !btn.isSelected
                if btn.isSelected {
                    getLocationStatus()
                }
                else {
//                    currentPostalCode = nil
//                    setLocationTextField.userInteractionEnabled = true
//                    setLocationFooterView.backgroundColor = UIColor(red: 108/255.0, green: 223/255.0, blue: 255/255.0, alpha: 1)
                }
            }
        }
    }
    
    //Mark: LocationManager Delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta :1 ,longitudeDelta :1 ))
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        
    }

    
//    override func viewDidAppear(_ animated: Bool) {
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "chad.png")!)
//
//    }
}
