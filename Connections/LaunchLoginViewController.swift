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

class LaunchLoginViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var authenticationView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.authenticationView.isHidden =  true
    }
  
    
    override func viewDidLoad() {
        //Set up the background  image style
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "style.jpeg")!)
        //Set up the authenticationView
        self.authenticationView.layer.cornerRadius = 10.0
        self.authenticationView.layer.borderWidth = 0.5
        self.authenticationView.clipsToBounds = true
        
        //Set up the loginButton
        self.loginButton.layer.borderWidth = 0.3
        self.loginButton.layer.borderColor = UIColor.white.cgColor
        self.loginButton.clipsToBounds = true
       
        
    }
    @IBAction func loginCliked (_ sender: AnyObject) {
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
        self.authenticationView.isHidden =  false
        //Check if the fingerprint is recognized
        authenticationContext.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Place finger to authenticate",
            reply: { (success, error) -> Void in
                
                if( success ) {
                    // Fingerprint recognized
                      print ("Fingerprint recognized")
                    
                    // hide the authenticationView
                  DispatchQueue.main.async {
                   self.view.backgroundColor = UIColor(patternImage: UIImage(named: "style.jpeg")!)
                    self.authenticationView.isHidden =  true
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
    
    func showAlertViewAfterEvaluatingPolicyWithMessage(message:String){
        showAlertWithTitle (title: "Error", message: message)
    }
    
    func showAlertViewIfNoBiometricSensorHasBeenDetected(){
        
        showAlertWithTitle(title: "Error", message: "This device does not have a TouchID sensor.")
        
    }
    
    func showAlertWithTitle( title:String, message:String ) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        
        DispatchQueue.main.async {
            
            self.present(alertVC, animated: true, completion: nil)
            // hide the authenticationView
            
           self.view.backgroundColor = UIColor(patternImage: UIImage(named: "style.jpeg")!)
            self.authenticationView.isHidden =  true
            
       }
        
    }

  
}
