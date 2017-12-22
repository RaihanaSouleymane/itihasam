//
//  LaunchLoginViewController.swift
//  VogueStore
//
//  Created by Macbook on 10/17/16.
//  Copyright © 2016 Raihana A. Souleymane. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication
import FBSDKCoreKit
import FBSDKLoginKit

class LaunchLoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var authenticationView: UIView!
    var facebookToken: String!
    let userDefaults = UserDefaults.standard
    
    override func viewWillAppear(_ animated: Bool) {
        self.authenticationView.isHidden =  true
    }
    
    
    override func viewDidLoad() {
        //Set up the background  image style
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "style.jpeg")!)
        //Set up the authenticationView
        self.authenticationView.layer.cornerRadius = 10.0
        self.authenticationView.layer.borderWidth = 0.5
        self.authenticationView.clipsToBounds = true
        
        //Set up the loginButton
        self.loginButton.layer.borderWidth = 0.3
        self.loginButton.layer.borderColor = UIColor.white.cgColor
        self.loginButton.clipsToBounds = true
        //hide loginbutton
        self.loginButton.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.facebookToken = userDefaults.object(forKey: "facebookToken") as? String
        self.performSegue(withIdentifier: "ToMainScreen", sender: self)
    }
    
    
    func setFingerPrintAuthentiation () {
        // Create an authentication context
        let authenticationContext = LAContext()
        
        var error:NSError?
        
        // Check if the device has a fingerprint sensor
        // If not, show the user an alert view and fade it out!
        guard authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            showAlertViewIfNoBiometricSensorHasBeenDetected()
            return
        }
        // show the authenticationView
        let color = UIColor.darkGray
        self.view.backgroundColor = color.withAlphaComponent(0.8)
        self.authenticationView.isHidden =  true
        //Check if the fingerprint is recognized
        authenticationContext.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "You are still logged in with Facebook.\n For your security, please place finger to authenticate",
            reply: { (success, error) -> Void in
                
                if( success ) {
                    // Fingerprint recognized
                    print ("Fingerprint recognized")
                    
                    // hide the authenticationView
                    DispatchQueue.main.async {
                        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "style.jpeg")!)
                        self.authenticationView.isHidden =  true
                        self.view.backgroundColor = UIColor.white
                    }
                    
                    // Go to view controller
                    self.performSegue(withIdentifier: "ToMainScreen", sender: self)
                    
                    
                }else {
                    
                    // Check if there is an error and handle it
                    if let error = error {
                        print("error", error)
                        self.showAlertViewAfterEvaluatingPolicyWithMessage(message: "")
                        
                    }
                    
                }
                
        })
        
        
        
        
    }
    
    @IBAction func loginCliked (_ sender: AnyObject) {
    }
    
    func showAlertViewAfterEvaluatingPolicyWithMessage(message:String){
        showAlertWithTitle (title: "Error", message: message)
    }
    
    func showAlertViewIfNoBiometricSensorHasBeenDetected(){
        
        self.performSegue(withIdentifier: "ToMainScreen", sender: self)
    }
    
    func showAlertWithTitle( title:String, message:String ) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        
        DispatchQueue.main.async {
            
            self.present(alertVC, animated: true, completion: nil)
            self.authenticationView.isHidden =  true
            self.view.backgroundColor = UIColor.white
            self.setFingerPrintAuthentiation()
            
        }
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    }
    
}
