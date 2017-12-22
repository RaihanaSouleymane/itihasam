//
//  DescriptionPost.swift
//  Connections
//
//  Created by Macbook on 10/16/16.
//  Copyright © 2016 Raihana A. Souleymane. All rights reserved.
//
import Foundation
import UIKit
import FBSDKShareKit
import FBSDKLoginKit
import MapKit

class DescriptionPost: UIViewController,FBSDKSharingDelegate,UINavigationControllerDelegate, UITextViewDelegate,CLLocationManagerDelegate,UITextFieldDelegate{
    
    @IBOutlet weak var LabelTitle: UILabel!
    
    @IBOutlet weak var articleTitle: UITextField!
    @IBOutlet weak var imageToUpload: UIImageView!
    
    @IBOutlet weak var myTextView: UITextView!
    
    
    var location: CGPoint = CGPoint()
    var centerOfMap: CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    var lastWidthInMetres: Double = 0
    
    
    @IBOutlet weak var bottomConst: NSLayoutConstraint!
    @IBOutlet weak var textViewPlaceHolder: UILabel!
    
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var uploadButton: UIBarButtonItem!
    
    var imagetoUpload : UIImage?
    var imageDatapng : Data?
    var longitute : String = "0.0"
    var latitude: String  = "0.0"
    
    override func viewDidAppear(_ animated: Bool) {
        //  self.imagetoUpload = Homepage.imagetoUpload
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 255.0/255.0, green: 87.0/255.0, blue: 34.0/255.0, alpha: 1.0)
    }
    
    override func viewDidLoad() {
        self.imagetoUpload = Homepage.imagetoUpload
        imageToUpload.layer.cornerRadius = 10.0
        imageToUpload.layer.borderColor = UIColor.gray.cgColor
        imageToUpload.layer.borderWidth = 0.5
        imageToUpload.clipsToBounds = true
        self.myTextView.delegate = self
        self.imageToUpload.image = imagetoUpload
        //print ("imagetoUpload",imagetoUpload!)
        self.myTextView.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
        
        self.articleTitle.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(DescriptionPost.keyboardWasShown), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DescriptionPost.keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        
        // get current location
        self.locationManager.delegate =  self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        
        
        
    }
    
    
    public func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        print("didCompleteWithResults")
        alertShow(title:"", message: "Photo")
    }
    
    public func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        print("didFailWithError")
    }
    
    public func sharerDidCancel(_ sharer: FBSDKSharing!) {
        print("sharerDidCancel")
    }
    
    func alertShow(title: String,message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { (UIAlertAction) in
            self.uploadButton.isEnabled =  true
            self.dismiss(animated: true) {
            }
        })
        )
        present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func cancelClick(_ sender: AnyObject) {
        
        self.dismiss(animated: true) {
            
        }
    }
    
    func addMultipartData(_ data: Data!,
                          withName name: String!,
                          type: String!){
        
    }
    
    
    @IBAction func uploadClick(_ sender: AnyObject) {
        
        
        if FBSDKAccessToken.current().hasGranted("publish_actions") {
            
            if (myTextView!.text != "") && (myTextView!.text != " ") && (articleTitle!.text != " ") && (articleTitle!.text != articleTitle.placeholder){
                //call facebook api here
                self.uploadButton.isEnabled =  false
                ABActivity.showActivityIndicator(self.view, text: "Uploading")
                
                
                var someImage = imagetoUpload
                var content = FBSDKSharePhotoContent()
                // content.description = "\(myTextView!.text)"
                
                let photo = FBSDKSharePhoto()
                photo.caption = myTextView!.text
                photo.image = someImage!
                photo.isUserGenerated = true
                
                
                content.photos = [photo]
                
                var dict = NSDictionary () as? [AnyHashable: Any] ?? [:]
                
                
                dict ["message"] = "\n\n\(articleTitle!.text!)\n\n\(myTextView!.text!)\n\nl:-\(self.latitude) L:-\(self.longitute)"
                
                dict ["source"] = imagetoUpload
                
                
                FBSDKGraphRequest.init(graphPath: "1809970652624352/photos", parameters: dict as [AnyHashable : Any]!, httpMethod: "POST").start(completionHandler: { (connection, result, error) -> Void in
                    if let error = error {
                        print("Error: \(error)")
                        ABActivity.hideActivityIndicator(self.view)
                        self.alertShow(title: "Failed to upload!",message: " please try again later" )
                    } else {
                        //  print (result)
                        ABActivity.hideActivityIndicator(self.view)
                        self.alertShow(title: "Your article has been uploaded!",message: "It will be published on Itihasam once it's approved by an Admin" )
                    }
                })
            }
                
            else{
                
                let alert = UIAlertController(title: "Please type or paste your article and its Title",
                                              message: "",
                                              preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK",
                                             style: .default) { (action: UIAlertAction) -> Void in
                }
                alert.addAction(okAction)
                
                present(alert,animated: true,completion: nil)
            }
            
        }
        else {
            self.alertShow(title: "Error", message: "Please try again later")
            print("require publish_actions permissions")
        }
        
        
    }
    
    
    
    // Mark: add helpful buttons above keyboard
    func cunstomKeyboard() -> UIToolbar{
        let keyboardToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height:35))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(DescriptionPost.done))
        
        
        keyboardToolBar.setItems([
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            doneButton
            ], animated: true)
        
        return keyboardToolBar
        
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView == myTextView{
            textView.inputAccessoryView = self.cunstomKeyboard()
            //textViewPlaceHolder.isHidden = true
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.articleTitle{
            textField.inputAccessoryView = self.cunstomKeyboard()
        }
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textViewPlaceHolder.isHidden = false
        }
        else {
            textViewPlaceHolder.isHidden = true
        }
    }
    
    
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            textViewPlaceHolder.isHidden = false
        }
        else {
            textViewPlaceHolder.isHidden = true
        }
    }
    
    
    
    func done(button:UIBarButtonItem) {
        self.myTextView.resignFirstResponder()
        self.articleTitle.resignFirstResponder()
        //performe Done or Submit action from the Keyboard Done click
        //self.submitButtonClick(self)
    }
    

    
    func keyboardWasShown(aNotification:NSNotification) {
        bottomConst.constant = 300.0
    }
    
    func keyboardWillBeHidden(aNotification:NSNotification) {
        bottomConst.constant = 20.0
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.latitude = "\(locValue.latitude)"
        self.longitute = "\(locValue.longitude)"
    }
    
    
    
    
}
