//
//  FBAnnotationClusterView.swift
//  FBAnnotationClusteringSwift
//
//  Created by Robert Chen on 4/2/15.
//  Copyright (c) 2015 Robert Chen. All rights reserved.
//

import Foundation
import MapKit

class FBAnnotationClusterView : MKAnnotationView {
    
    var count = 0
 
    var fontSize:CGFloat = 12
    
    var imageName = "redBig"
    
    var countLabel:UILabel?
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?){
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        let cluster:FBAnnotationCluster = annotation as! FBAnnotationCluster
        cluster.clusterView = self
        count = cluster.annotations.count

        print ("Totalcount",WebService.sharedInstance.crimeArray.count)

        
        // change the size of the cluster image based on number of reported Crimes
            switch count {
            case 0...(WebService.sharedInstance.crimeArray.count/4):
                fontSize = 12
                imageName = "blueSmall"
          
            case (WebService.sharedInstance.crimeArray.count/4)...2*(WebService.sharedInstance.crimeArray.count/3):
                fontSize = 12
                imageName = "orangeSmall"
               
            case 2*(WebService.sharedInstance.crimeArray.count/3)...(WebService.sharedInstance.crimeArray.count):
                fontSize = 12
                imageName = "redSmall"
                
            default:
                fontSize = 14
                imageName = "redBig"
                
            }
            setupLabel()
            setTheCount(count)
        
        backgroundColor = UIColor.clear
        setNeedsLayout()
    }
    
//     override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//    }
//    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupLabel(){
        countLabel = UILabel(frame: bounds)
        
        if let countLabel = countLabel {
            countLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            countLabel.textAlignment = .center
            countLabel.backgroundColor = UIColor.clear
            countLabel.textColor = UIColor(red: 24/255, green: 36/255, blue: 73/255, alpha: 0.6)
            countLabel.adjustsFontSizeToFitWidth = true
            countLabel.minimumScaleFactor = 2
            countLabel.numberOfLines = 1
            countLabel.font = UIFont (name: "pfdintextpro-medium", size: fontSize)
            countLabel.baselineAdjustment = .alignCenters
            addSubview(countLabel)
        }
        
    }
    
    func setTheCount(_ localCount:Int){
        count = localCount;
        countLabel?.text = "\(localCount)"
    }
    
    override func layoutSubviews() {
        
        let imageAsset = UIImage(named: imageName)!
        countLabel?.frame = self.bounds
        image = imageAsset
        centerOffset = CGPoint.zero
        }
    }
