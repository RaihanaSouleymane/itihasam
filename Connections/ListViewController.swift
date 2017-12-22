//
//  ListViewController.swift
//  Connections
//
//  Created by Macbook on 9/18/16.
//  Copyright © 2016 Raihana A. Souleymane. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

//Camera/Photo related Framework

import Photos
import AVKit
import AVFoundation
import MediaPlayer
import MobileCoreServices

class ListViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var mapButton: UIButton!
    
    @IBOutlet weak var listButton: UIButton!
    
    @IBOutlet weak var settingButton: UIBarButtonItem!
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
     
    let photoPicker = UIImagePickerController()
    var secondBtn: UIBarButtonItem!
    var firstBtn : UIBarButtonItem!
    var thirdBtn:  UIBarButtonItem!
    
    var facebookToken: String!
    let userDefaults = UserDefaults.standard
    
    
    override func viewWillAppear(_ animated: Bool) {
        

        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapButton.backgroundColor = UIColor(red: 33.0/255.0, green: 150.0/255.0, blue: 243.0/255.0, alpha: 0.7)
        self.listButton.backgroundColor = UIColor(red: 33.0/255.0, green: 150.0/255.0, blue: 243.0/255.0, alpha: 1)
        self.mapButton = ButtonModel.GhostActionButton(text: "Map!", foregroundColor: UIColor.white, button:self.mapButton)
        self.mapButton.layer.cornerRadius = self.mapButton.height / 2
        self.listButton = ButtonModel.GhostActionButton(text: "List!", foregroundColor: UIColor.white, button:self.listButton)
        self.listButton.layer.cornerRadius = self.listButton.height / 2
        

        
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
    
        
              // Do any additional setup after loading the view, typically from a nib.
    }
    func requestCameraAccess ()  {
    
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

 
    
    
    @IBAction func mapListClick(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
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
}
