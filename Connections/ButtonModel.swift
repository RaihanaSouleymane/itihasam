//
//  ButtonModel.swift
//  Itihasam
//
//  Created by Macbook on 10/6/17.
//  Copyright © 2017 Raihana A. Souleymane. All rights reserved.
//

import Foundation
import UIKit

class ButtonModel: NSObject {
    
    class func GhostActionButton(text: String, foregroundColor: UIColor, button : UIButton? = nil) -> UIButton {
        var ghostButton : UIButton
        let backgroundColor = UIColor.clear
        
        if let button = button {
            ghostButton = button
        } else {
            ghostButton = UIButton.init(type: .custom)
        }
        
        ghostButton.setTitle(text, for: .normal)
        ghostButton.setTitleColor(foregroundColor, for: .normal)
        ghostButton.setBackgroundImage(UIImage.imageWithColor(color: backgroundColor, alpha: 1.0), for: .normal)
        ghostButton.setTitleColor(UIColor.white, for: .highlighted)
        ghostButton.setBackgroundImage(UIImage.imageWithColor(color: foregroundColor, alpha: 1.0), for: .highlighted)
        
        // border
        ghostButton.layer.borderColor = foregroundColor.cgColor
        ghostButton.layer.borderWidth = 2.0
        ghostButton.clipsToBounds = true
        
        return ghostButton
    }
    
    class func navigationBarButton(imageName: String, preferredSideLength: CGFloat) -> UIBarButtonItem {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect.init(x: 0, y: 0, width: preferredSideLength, height: preferredSideLength)
        button.setImage(UIImage.init(named: imageName), for: .normal)
        return UIBarButtonItem.init(customView: button)
    }
}
