//
//  LoginPage.swift
//  Connections
//
//  Created by Macbook on 10/5/16.
//  Copyright © 2016 Raihana A. Souleymane. All rights reserved.
//

import Foundation
import UIKit
import FacebookCore
import FacebookLogin
import FBSDKLoginKit

class LoginPage: UIViewController, FBSDKLoginButtonDelegate{
  
    
    @IBOutlet weak var singUpButton: UIButton!
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var forgotButton: UIButton!
    
    @IBOutlet weak var signInButton: UIButton!
    var facebookToken: String!
     let userDefaults = UserDefaults.standard
    
    
    @IBAction func signInUpForgotClik(_ sender: AnyObject) {
        let alert: UIAlertView = UIAlertView(title: "Coming Soon", message: "This feature is Coming Soon", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
        

    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
    
        self.facebookToken = userDefaults.object(forKey: "facebookToken") as? String
        
        if self.facebookToken != nil {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ToListView") {
               self.present(vc, animated: true, completion: nil)}
            
        }
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 255.0/255.0, green: 87.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        
        self.navigationItem.title = "Sign Up/Log In"
        
//Add back button with action trigger
//   self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackBlack"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(LoginPage.backClickAction))
//        
        
        
//    self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
//    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:"Search", style: UIBarButtonItemStyle.plain, target: self, action: Selector("searchClickAction"))
//    self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black

    }

    
    override func viewDidLoad() {
        print ("facebookButton", facebookButton.frame.size.width)
        let loginButton = FBSDKLoginButton(type: UIButtonType.custom)
        loginButton.readPermissions = ["public_profile", "email", "user_friends","user_likes","user_posts","user_photos"]
        
        loginButton.publishPermissions = ["publish_actions"]
        
       // loginButton.frame = CGRect(x: 20,y: self.facebookButton.frame.origin.y, width: self.facebookButton.frame.size.width, height: self.facebookButton.frame.size.height)
        
        //loginButton.frame = CGRect(x: 0,y: 0, width: self.facebookButton.bounds.size.width/2, height: 40)
        
        //loginButton.center = self.logInButton.center
        //CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 110)
loginButton.frame = CGRect(x: 20,y: self.view.frame.size.height - 250, width: self.view.frame.size.width-40, height: 40)
        
       // loginButton.frame = self.facebookButton.frame
        //loginButton.center = self.view.center
        //CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 110)
        loginButton.delegate = self
        //Hide facebook button
         self.view.addSubview(loginButton)
    }

    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if let error = error {
            
            print("Facebook signup error - \(error.localizedDescription)")
            
        } else if result != nil {
            
            if (result?.isCancelled)! {
                
                print("it is cancelled")
                // Handle cancellations
            }
            else {
                print("you are connected", result.token.tokenString)
                self.facebookToken = result.token.tokenString
             
                userDefaults.setValue(result.token.tokenString, forKey: "facebookToken")
                userDefaults.synchronize()
                
                // go to homepage
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ToListView") {
                    self.present(vc, animated: true, completion: nil)}
            }
            // self.performSegue(withIdentifier: "ToListView", sender: self)
            
        }
        
        
        
        
        var Requset : FBSDKGraphRequest
        var parameters1 = ["fields" : "id, name, email, user_posts"]
        
        
       // let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, email"])
        
        Requset  = FBSDKGraphRequest(graphPath:"{user_id}/photos", parameters:parameters1, httpMethod:"GET")
        
        print ("Requset",Requset)
        Requset.start(completionHandler: { (connection, result, error) -> Void in
            
             let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //MBProgressHUD.hideHUDForView(appDelegate.window, animated: true)
            
     
            
            if ((error) != nil)
            {
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                
               // var dataDict: AnyObject = result!.objectForKey("data")!
                print(result!)
            }
        })
        
    
        }
    

    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        print("you are disconnected")
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        // remove facebookToken from Userdefault
        userDefaults.removeObject(forKey: "facebookToken")
    }
//    func backClickAction(){
//        self.navigationController?.popViewController(animated: true)
//    }

    @IBAction func guestClick(_ sender: AnyObject) {
//        self.performSegue(withIdentifier: "ToCollectionView", sender: self)
    }
    
    
    @IBAction func termsAnsConditionTapped(_ sender: Any) {
        
        guard let url = URL(string: "http://itihasam.org/privacypolicy.html") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    @IBAction func tapGesture(_ sender: AnyObject) {
        self.view.endEditing(true)
    }
}
