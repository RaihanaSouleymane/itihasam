//
//  CollectionView.swift
//  Connections
//
//  Created by Macbook on 10/5/16.
//  Copyright © 2016 Raihana A. Souleymane. All rights reserved.
//

import Foundation
import UIKit

class CollectionView: UICollectionViewController{
    
    
    @IBOutlet weak var settingButton: UIBarButtonItem!
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Itihasam"
        
        
    
    }
    override func viewDidLoad() {
        
        
        self.settingButton.title = NSString(string: "\u{2699}") as String
        if let font = UIFont(name: "Helvetica", size: 18.0) {
            self.settingButton.setTitleTextAttributes([NSFontAttributeName: font], for: UIControlState.normal)
        }
        

        
    }
    
   
    @IBAction func menuClick(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "ToMenu", sender: self)
        
    }
    
    @IBAction func searchClick(_ sender: AnyObject) {
    }
    
    

}
