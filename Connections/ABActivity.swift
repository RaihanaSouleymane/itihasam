//
//  ABActivity.swift
//
//  Created by Macbook on 10/10/16.
//  Copyright © 2016 Raihana A. Souleymane. All rights reserved.
//

import UIKit

open class ABActivity: NSObject {
    static let activityViewTag = 50005
    
    open class func showActivityIndicator(_ view:UIView?, text:String) {
        if let _ = view?.viewWithTag(activityViewTag) {}
        else if let _ = UIApplication.shared.delegate?.window??.viewWithTag(activityViewTag) {}
        else {
            let tempView : UIView = UIView()
            tempView.frame = CGRect(x: UIScreen.main.bounds.width/2 - 50, y: UIScreen.main.bounds.height/2 - 100, width: 100, height: 100)
            tempView.tag = activityViewTag
            tempView.backgroundColor = UIColor.clear

            let roundView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            roundView.backgroundColor = UIColor.black
            roundView.layer.cornerRadius = 5
            roundView.layer.masksToBounds = true
            roundView.alpha = 0.8
            tempView.addSubview(roundView)

            let activityView = UIActivityIndicatorView(frame: CGRect(x: 34, y: 28, width: 32, height: 32))
            activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            activityView.backgroundColor = UIColor.clear
            if text == "" {
                activityView.frame = CGRect(x: 34, y: 34, width: 32, height: 32)
            }
            tempView.addSubview(activityView)
            activityView.startAnimating()

            let statusLabel = UILabel(frame: CGRect(x: 5, y: 64, width: 91, height: 32))
            statusLabel.text = text
            statusLabel.backgroundColor = UIColor.clear
            statusLabel.textColor = UIColor.white
            statusLabel.textAlignment = NSTextAlignment.center
            statusLabel.font = UIFont.systemFont(ofSize: 11)
            tempView.addSubview(statusLabel)

            if let abView = view {
                abView.addSubview(tempView)
            }
            else if let abView = UIApplication.shared.delegate?.window {
                abView?.addSubview(tempView)
            }
        }
    }

    class func hideActivityIndicator(_ view:UIView?) {
        if let abView = view?.viewWithTag(activityViewTag) {
            abView.removeFromSuperview()
        }
        else if let appDelegate = UIApplication.shared.delegate {
            if let tmpView = appDelegate.window??.viewWithTag(activityViewTag) {
                tmpView.removeFromSuperview()
            }
        }
    }
    
}
