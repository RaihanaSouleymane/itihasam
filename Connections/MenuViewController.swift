//
//  MenuViewController.swift
//  Connections
//
//  Created by Macbook on 10/14/16.
//  Copyright © 2016 Raihana A. Souleymane. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class MenuViewController: UIViewController, FBSDKLoginButtonDelegate{
    var facebookToken: String!
    let userDefaults = UserDefaults.standard
    
    
    @IBOutlet weak var myView1: UIView!
    @IBOutlet weak var myView2: UIView!
    
    @IBOutlet weak var myView3: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.facebookToken = userDefaults.object(forKey: "facebookToken") as? String
        
        if self.facebookToken != nil {
           //already logged in
        
        }
        self.navigationItem.title = "Menu"
    }
    
    
    func viewShape(myView:UIView){
        myView.layer.cornerRadius = 1.0
        myView.layer.borderColor = UIColor.lightGray.cgColor
        myView.layer.borderWidth = 1.0
        myView.clipsToBounds = true
        
    }
    
    override func viewDidLoad() {
        
        let allViews = [myView1,myView2,myView3]
        for theView in allViews {
       self.viewShape(myView: theView!)
        }
        
        
       // print ("facebookButton", facebookButton.frame.size.width)
        let loginButton = FBSDKLoginButton(type: UIButtonType.custom)
        loginButton.readPermissions = ["public_profile","email", "user_friends","user_likes","user_posts","user_photos"]
         loginButton.publishPermissions = ["publish_actions"]
        
        // loginButton.frame = CGRect(x: 20,y: self.facebookButton.frame.origin.y, width: self.facebookButton.frame.size.width, height: self.facebookButton.frame.size.height)
        
        //loginButton.frame = CGRect(x: 0,y: 0, width: self.facebookButton.bounds.size.width/2, height: 40)
        
        //loginButton.center = self.logInButton.center
        //CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 110)
       // loginButton.frame = CGRect(x: 20,y: self.view.frame.size.height - 50, width: self.view.frame.size.width-40, height: 40)
        loginButton.frame = CGRect(x: 20,y: self.view.frame.size.height - 100, width: self.view.frame.size.width-40, height: 40)
        
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
        var parameters1 = ["access_token":result.token.tokenString]
        
        
        Requset  = FBSDKGraphRequest(graphPath:"me/posts", parameters:parameters1, httpMethod:"GET")
        
    
        
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
        //go to LoginPage
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginPage") {
            self.present(vc, animated: true, completion: nil)}
    }
    
    

}
