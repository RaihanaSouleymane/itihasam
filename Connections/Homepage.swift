//
//  Homepage.swift
//  Connections
//
//  Created by Macbook on 9/18/16.
//  Copyright © 2016 Raihana A. Souleymane. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import FBSDKShareKit
import FBSDKLoginKit

//Camera/Photo related Framework

import Photos
import AVKit
import AVFoundation
import MediaPlayer
import MobileCoreServices


class Homepage: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate,FBSDKSharingDelegate,FBSDKLoginButtonDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverPresentationControllerDelegate, MapViewDelegate{
    /*!
     @abstract Sent to the delegate when the share completes without error or cancellation.
     @param sharer The FBSDKSharing that completed.
     @param results The results from the sharer.  This may be nil or empty.
     */
    static let sharedInstance = Homepage()
    var theArticle = [Article]()
    
    static var imagetoUpload : UIImage?
    
    @IBOutlet weak var mapButton: UIButton!
    
    @IBOutlet weak var listButton: UIButton!
    
    @IBOutlet weak var settingButton: UIBarButtonItem!
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    var secondBtn: UIBarButtonItem!
    var firstBtn : UIBarButtonItem!
    var thirdBtn:  UIBarButtonItem!
    var facebookToken: String!
    let userDefaults = UserDefaults.standard
   // var photoSourceValue: String?
    
    // @IBOutlet weak var mapView: MKMapView!
    // @IBOutlet weak var mapView: MapView! //mkMapView
    
    let photoPicker = UIImagePickerController()
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MapView!
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.delegate = self
        self.mapView.clusteringManager.deleteAllAnnotations()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 255.0/255.0, green: 87.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        // call API and Show the Clusters
        
        self.apiCall()
    }
    
    func apiCall (){
        self.facebookToken = userDefaults.object(forKey: "facebookToken") as? String
        ABActivity.showActivityIndicator(self.view, text: "")
        if self.facebookToken != nil {
            
            if FBSDKAccessToken.current().hasGranted("publish_actions") {
                
                FBSDKGraphRequest.init(graphPath: "1809970652624352/feed?fields=place,message,likes,created_time,object_id,picture,full_picture,from", parameters: [:], httpMethod: "GET").start(completionHandler: { (connection, result, error) -> Void in
                    if let error = error {
                        print("Error: \(error)")
                    } else {
                        print ("result",result!)
                        
                        
                        if let response = result as? NSDictionary{
                            if let theData = response.object(forKey:"data") as? NSArray {
                                
                                self.theArticle.removeAll()
                                for resp in theData {
                                    if (resp as!NSDictionary).object(forKey: "message") != nil
                                    {
                                        let myresp = Article(JSON :resp as! NSDictionary)
                                        self.theArticle.append(myresp)
                                    }
                                    else {
                                        if (resp as!NSDictionary).object(forKey: "story") != nil
                                        {
                                            let myresp = Article(JSON :resp as! NSDictionary)
                                        }
                                    }
                                }
                            }
                            DispatchQueue.main.async( execute: {
                                self.mapView.clusteringManager.addAnnotations(self.theArticle)
                                
                            })
                        }
                    }
                })
            }
            
            ABActivity.hideActivityIndicator(self.view)
            
        }
        else {
            self.theArticle = []
            ABActivity.hideActivityIndicator(self.view)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.apiCall()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.apiCall()
        let loginButton = FBSDKLoginButton()
        loginButton.center = CGPoint(x: view.center.x, y: 300)
        loginButton.delegate = self
        loginButton.readPermissions = ["public_profile", "email", "user_friends","user_likes","user_posts","user_photos"]
        loginButton.publishPermissions = ["publish_actions"]
        
        
        let imgFirst = UIImage(named: "posts")?.withRenderingMode(.alwaysOriginal)
        firstBtn = UIBarButtonItem(image: imgFirst, style: UIBarButtonItemStyle.done, target: self,action: #selector(Homepage.action1))
        
        //let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        // space.width = 25.0
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil);
        
        firstBtn.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        
        
        let imgSecond = UIImage(named: "myposts")?.withRenderingMode(.alwaysOriginal)
        secondBtn = UIBarButtonItem(image: imgSecond, style: UIBarButtonItemStyle.done, target: self,action: #selector(Homepage.action2))
        // secondBtn.imageInsets = UIEdgeInsetsMake(0, 50, 0, 0)
        
        let imgThird = UIImage(named: "add")?.withRenderingMode(.alwaysOriginal)
        thirdBtn = UIBarButtonItem(image: imgThird, style: UIBarButtonItemStyle.done, target: self, action: #selector(Homepage.action3))
        
        // thirdBtn.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        
        self.setToolbarItems([firstBtn,flexibleSpace,secondBtn,flexibleSpace,thirdBtn], animated: true)
        
        // self.view.backgroundColor = UIColor(patternImage: UIImage(named: "chad.png")!)
        
        self.settingButton.title = NSString(string: "\u{2699}") as String
        if let font = UIFont(name: "Helvetica", size: 18.0) {
            self.settingButton.setTitleTextAttributes([NSFontAttributeName: font], for: UIControlState.normal)
        }
    
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "chad.png")
        // you can change the content mode:
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFit
        
        self.view.insertSubview(backgroundImage, at: 0)
        getFacebookUserInfo()
    }
    
    public func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        print("didCompleteWithResults")
        alertShow(typeStr: "Photo")
    }
    
    public func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        print("didFailWithError")
    }
    
    public func sharerDidCancel(_ sharer: FBSDKSharing!) {
        print("sharerDidCancel")
    }
    
    func alertShow(typeStr: String) {
        let alertController = UIAlertController(title: "", message: typeStr+" Posted!", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func requestCameraAccess () {
        
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: {
            granted in
            DispatchQueue.main.async {
                if granted {
                    self.showImagePickerForSourceType(UIImagePickerControllerSourceType.camera)
                    //self.photoSourceValue = "Camera"
                } else {
                    let alertController=UIAlertController(title: "Itihasam doesn't have access to your camera", message: "Please go to the app settings and enable the camera.", preferredStyle: UIAlertControllerStyle.alert);
                    
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                    
                    alertController.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.default)
                    { action -> Void in
                        
                        let settingsUrl = NSURL(string:UIApplicationOpenSettingsURLString)
                        UIApplication.shared.openURL(settingsUrl! as URL)
                    })
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }
        })
    }
    
    
    func requestGalleryAccess () {
        
        PHPhotoLibrary.requestAuthorization({ (status) -> Void in
            
      
            DispatchQueue.main.async {
    
        if status == .authorized {
            //  Permission Authorized
            if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)) {
                //check for per
                self.photoPicker.delegate = self
                self.photoPicker.allowsEditing = false
                self.photoPicker.mediaTypes = [String(kUTTypeImage)]
                self.photoPicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                
                self.present(self.photoPicker, animated: true, completion: nil)
            }
            
        } else if status == .restricted {
            
            let alertController=UIAlertController(title: "Itihasam doesn't have access to your Gallery", message: "Please go to the app settings and enable it.", preferredStyle: UIAlertControllerStyle.alert);
            
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            
            alertController.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.default)
            { action -> Void in
                
                let settingsUrl = NSURL(string:UIApplicationOpenSettingsURLString)
                UIApplication.shared.openURL(settingsUrl! as URL)
            })
            self.present(alertController, animated: true, completion: nil)
        } else if status == .notDetermined {
           
        } else if status == .denied {
            let alertController=UIAlertController(title: "Itihasam doesn't have access to your Gallery", message: "Please go to the app settings and enable it.", preferredStyle: UIAlertControllerStyle.alert);
            
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            
            alertController.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.default)
            { action -> Void in
                
                let settingsUrl = NSURL(string:UIApplicationOpenSettingsURLString)
                UIApplication.shared.openURL(settingsUrl! as URL)
            })
            self.present(alertController, animated: true, completion: nil)
        }
        

    }
        })
    }
    
    func showImagePickerForSourceType(_ sourceType:UIImagePickerControllerSourceType)
    {
        DispatchQueue.main.async {
            if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
                self.photoPicker.delegate = self
                self.photoPicker.allowsEditing = false
                self.photoPicker.mediaTypes = [String(kUTTypeImage)] //[String(kUTTypeImage), String(kUTTypeMovie)]
                self.photoPicker.sourceType = UIImagePickerControllerSourceType.camera
                self.photoPicker.popoverPresentationController?.delegate = self
                self.photoPicker.modalPresentationStyle = .pageSheet
                self.present(self.photoPicker, animated: true, completion: nil)
            }
 
    }
   
}
    
    func action3(){
        
        // check if already connected with facebook
        self.facebookToken = userDefaults.object(forKey: "facebookToken") as? String
        
    if self.facebookToken != nil {
            //already logged in
            
            
            thirdBtn.image = UIImage(named: "addClicked")?.withRenderingMode(.alwaysOriginal)
            firstBtn.image = UIImage(named: "posts")?.withRenderingMode(.alwaysOriginal)
            secondBtn.image = UIImage(named: "myposts")?.withRenderingMode(.alwaysOriginal)
            
            print ("to upload")
            // prompt the camera view
            
            let photoSourceAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.alert)
            let cancel = UIAlertAction(title:"Cancel", style: UIAlertActionStyle.cancel, handler: {(UIAlertAction) in
                self.thirdBtn.image = UIImage(named: "add")?.withRenderingMode(.alwaysOriginal)
            })
            photoSourceAlert.addAction(cancel)
        if(UIImagePickerController.isCameraDeviceAvailable(.rear)) {
            let takePhoto = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.default, handler: {(UIAlertAction) in
                self.requestCameraAccess()

            })
            photoSourceAlert.addAction(takePhoto)
        }
            let choosePhotoFromLibrary = UIAlertAction(title: "Choose Photo", style: UIAlertActionStyle.default, handler: {(UIAlertAction) in
                
                self.requestGalleryAccess()
                
                                           })
            photoSourceAlert.addAction(choosePhotoFromLibrary)
            photoSourceAlert.popoverPresentationController?.sourceView = self.view
            photoSourceAlert.popoverPresentationController?.permittedArrowDirections = .up
            photoSourceAlert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            
            
            self.present(photoSourceAlert, animated: true, completion: nil)
            
            }
            
        else{
        
        let loginAlert = UIAlertController(title: "You need to be connected with facebook in order to upload"  , message: nil, preferredStyle: UIAlertControllerStyle.alert)
            let cancel = UIAlertAction(title:"Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            loginAlert.addAction(cancel)
            let OK = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(UIAlertAction) in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginPage") as! UINavigationController
                
                self.present(vc, animated: true, completion: nil)
                
            })
            loginAlert.addAction(OK)
            self.present(loginAlert, animated: true, completion: nil)
        }
    }

    func action2(){
        secondBtn.image = UIImage(named: "mypostsClicked")?.withRenderingMode(.alwaysOriginal)
        thirdBtn.image = UIImage(named: "add")?.withRenderingMode(.alwaysOriginal)
        firstBtn.image = UIImage(named: "posts")?.withRenderingMode(.alwaysOriginal)
    }
    
    func action1(){
        firstBtn.image = UIImage(named: "postsClicked")?.withRenderingMode(.alwaysOriginal)
        thirdBtn.image = UIImage(named: "add")?.withRenderingMode(.alwaysOriginal)
        secondBtn.image = UIImage(named: "myposts")?.withRenderingMode(.alwaysOriginal)
    
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
                    getLocationStatus()
                }
            }
        }
    }

    @IBAction func mapListClick(_ sender: AnyObject) {
    }
    
    func getFacebookUserInfo() {
        if(FBSDKAccessToken.current() != nil)
        {
            //print permissions, such as public_profile
            print(FBSDKAccessToken.current().permissions)
            print("FBSDKAccessToken", FBSDKAccessToken.current().tokenString, FBSDKAccessToken.current())
            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: [:])
            // print (graphRequest)
            
            graphRequest?.start(completionHandler: { (connection, result, error) -> Void in
                if result != nil {
                    //  print ("result",result!,error)
                }
                //                self.label.text = result.valueForKey(forKey:"name") as? String
                //
                //                let FBid = result.value(forKey:"id") as? String
                //
                //                let url = NSURL(string: "https://graph.facebook.com/\(FBid!)/picture?type=large&return_ssl_resources=1")
                //                self.imageView.image = UIImage(data: NSData(contentsOfURL: url!)!)
            })
        } else {
            
            // buttonEnable(false)
        }
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        getFacebookUserInfo()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("loginButtonDidLogOut")
    }
    
    // MARK: - UIImagePickerController Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true) { () -> Void in
            if(picker == self.photoPicker) {
                
                
                if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                    print( "this is the image from camera",chosenImage)
                    // go to description view
                    
                    Homepage.imagetoUpload = chosenImage
                    //DescriptionPost
                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "DescriptionPostNav") {
                        
                        //                        if let description = self.storyboard?.instantiateViewController(withIdentifier: "DescriptionPost") as? DescriptionPost {
                        //
                        //                           // description.imagetoUpload = chosenImage
                        //                        }
                        self.present(vc, animated: true, completion: nil)}
                    
                }
            }
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        thirdBtn.image = UIImage(named: "add")?.withRenderingMode(.alwaysOriginal)
    }
    func annotationSelected(_ mapView: MapView, didSelectAnnotationView view: MKAnnotationView){
        //print ("selected here", (view.annotation as? Article)!)
        if ((view.annotation)?.isKind(of: FBAnnotationCluster.self))!{
            
        }
        else if ((view.annotation)?.isKind(of: MKUserLocation.self))! {
        }
        else{
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "details") as? DetailsViewController{
                vc.theArticle = [(view.annotation as? Article)!]
                
                self.navigationController!.pushViewController(vc, animated: true)
                
                // go to descrpition page from here by passing the article dtaa
            }
            
            
        }
    }
    
 


    
    
}
