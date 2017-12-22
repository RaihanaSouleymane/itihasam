//
//  Constraints.swift
//  Itihasam
//
//  Created by Macbook on 10/6/17.
//  Copyright © 2017 Raihana A. Souleymane. All rights reserved.
//

import Foundation
import UIKit

// Key:
//  - constrainInsideXXX - constrain this view to a parent
//  - constrainXXX - constrain this view to a sibling
//

extension UIView {
    
    // MARK: First, some easy access to frame values
    public var x: CGFloat {
        return self.frame.origin.x
    }
    
    public var y: CGFloat {
        return self.frame.origin.y
    }
    
    public var width: CGFloat {
        return self.frame.size.width
    }
    
    public var bwidth: CGFloat {
        return self.bounds.size.width
    }
    
    public var height: CGFloat {
        return self.frame.size.height
    }
    
    public var bheight: CGFloat {
        return self.bounds.size.height
    }
    
    public var right: CGFloat {
        return x + width
    }
    
    public var bottom: CGFloat {
        return y + height
    }
    
    // MARK: These don't fit the key above - they do various size/inside constraints
    //
    
    public func constrainToRightEdgeOf(constrainInside: UIView, offset : CGFloat) -> NSLayoutConstraint {
        self.prepForConstraints()
        
        return self.doConstrainRight(constrainTo: constrainInside, amount: offset)
    }
    
    public func constrainToLeftEdgeOf(constrainInside: UIView, offset : CGFloat) -> NSLayoutConstraint {
        self.prepForConstraints()
        
        return self.doConstrainLeft(constrainTo: constrainInside, amount: offset)
    }
    
    public func constrainLeftToRightOf(constrainInside: UIView, offset: CGFloat) -> NSLayoutConstraint {
        self.prepForConstraints()
        
        return self.doConstrainLeftRight(constrainTo: constrainInside, amount: offset)
    }
    
    public func constrainFitInside(constrainInside: UIView) -> [NSLayoutConstraint] {
        self.prepForConstraints()
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(self.doConstrainLeft(constrainTo: constrainInside))
        constraints.append(self.doConstrainTop(constrainTo: constrainInside))
        constraints.append(self.doConstrainWidth(constrainTo: constrainInside))
        constraints.append(self.doConstrainHeight(constrainTo: constrainInside))
        
        return constraints
    }
    
    public func constrainFitInsideEdges(constrainInside: UIView) -> [NSLayoutConstraint] {
        self.prepForConstraints()
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(self.doConstrainLeft(constrainTo: constrainInside))
        constraints.append(self.doConstrainTop(constrainTo: constrainInside))
        constraints.append(self.doConstrainRight(constrainTo: constrainInside))
        constraints.append(self.doConstrainBottom(constrainTo: constrainInside))
        
        return constraints
    }
    
    public func constrainFitInside(constrainInside: UIView, insets: UIEdgeInsets) -> [NSLayoutConstraint] {
        self.prepForConstraints()
        
        var constraints = [NSLayoutConstraint]()
        
        let left = self.doConstrainLeft(constrainTo: constrainInside, amount: insets.left)
        left.identifier = "left"
        constraints.append(left)
        
        let top = self.doConstrainTop(constrainTo: constrainInside, amount: insets.top)
        top.identifier = "top"
        constraints.append(top)
        
        let right = self.doConstrainRight(constrainTo: constrainInside, amount: insets.right)
        right.identifier = "right"
        constraints.append(right)
        
        let bottom = self.doConstrainBottom(constrainTo: constrainInside, amount: insets.bottom)
        bottom.identifier = "bottom"
        constraints.append(bottom)
        
        return constraints
    }
    
    // don't fit bottom
    public func constrainFitInsideTLR(constrainInside: UIView) -> [NSLayoutConstraint] {
        self.prepForConstraints()
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(self.doConstrainTop(constrainTo: constrainInside))
        constraints.append(self.doConstrainLeft(constrainTo: constrainInside))
        constraints.append(self.doConstrainRight(constrainTo: constrainInside))
        
        return constraints
    }
    
    public func constrainSize(width: CGFloat, height: CGFloat) -> (NSLayoutConstraint?, NSLayoutConstraint?) {
        self.prepForConstraints()
        
        return (self.doConstrainWidthValue(amount: width), self.doConstrainHeightValue(amount: height))
    }
    
    public func constrainCenterInside(constrainInside: UIView, offsetX: CGFloat=0.0, offsetY: CGFloat=0.0) {
        self.prepForConstraints()
        
        self.doConstrainCenterX(constrainTo: constrainInside, amount: offsetX)
        self.doConstrainCenterY(constrainTo: constrainInside, amount: offsetY)
    }
    
    public func constrainCenterHorizontallyInside(constrainInside: UIView) {
        self.prepForConstraints()
        self.doConstrainCenterX(constrainTo: constrainInside)
    }
    
    public func constrainCenterVerticallyInside(constrainInside: UIView) {
        self.prepForConstraints()
        self.doConstrainCenterY(constrainTo: constrainInside)
    }
    
    public func constrainCenterVerticallyInside(constrainInside: UIView, leftOffset: CGFloat, rightOffset: CGFloat) {
        self.prepForConstraints()
        
        self.doConstrainLeft(constrainTo: constrainInside, amount: leftOffset)
        self.doConstrainRight(constrainTo: constrainInside, amount: rightOffset)
        self.doConstrainCenterY(constrainTo: constrainInside)
    }
    
    public func constrainCenterYInside(constrainInside: UIView) {
        self.prepForConstraints()
        
        self.doConstrainCenterY(constrainTo: constrainInside, amount: 0)
    }
    
    public func constrainCenterXInside(constrainInside: UIView) {
        self.prepForConstraints()
        
        self.doConstrainCenterX(constrainTo: constrainInside, amount: 0)
    }
    
    public func constrainYCenter(to: UIView, offset: CGFloat = 0) -> NSLayoutConstraint {
        self.prepForConstraints()
        
        return self.doConstrainCenterY(constrainTo: to, amount: offset)
    }
    
    // MARK: Stacks
    //
    
    // constrain the parent's height to fit the contents of the children
    public func constrainVerticalStackForContainer(views: [UIView], sizes: [CGFloat], lineSpacing: CGFloat, edgeInsets: UIEdgeInsets?) {
        if views.count == 0 || views.count != sizes.count {
            // nothing to do
            return
        }
        
        self.prepForConstraints()
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        var bottomInset: CGFloat = 0
        var rightInset: CGFloat = 0
        
        print(edgeInsets)
        
        if let edgeInsets = edgeInsets {
            x = edgeInsets.left
            y = edgeInsets.top
            bottomInset = edgeInsets.bottom
            rightInset = edgeInsets.right
        }
        
        for (index, view) in views.enumerated() {
            view.constrainInsideTopLeft(constrainInside: self, amountX: x, amountY: y)
            
            y += sizes[index]
            
            if index == views.count-1 {
                if let edgeInsets = edgeInsets {
                    y += edgeInsets.bottom
                }
                
                view.constrainInsideBottomLeft(constrainInside: self, amountX: x, amountY: bottomInset)
            } else {
                y += lineSpacing
            }
            
            view.constrainHeight(height: sizes[index])
            view.constrainToWidth(constrainTo: self, amount: -x-rightInset)
        }
    }
    
    // MARK: Aspect
    public func constrainAspect(ratio: CGFloat) -> NSLayoutConstraint {
        self.prepForConstraints()
        
        return self.doConstrainAspect(amount: ratio)
    }
    
    // MARK: Width
    //
    
    public func constrainWidthGreaterOrEqual(width: CGFloat) -> NSLayoutConstraint {
        self.prepForConstraints()
        let constraint = self.doConstrainWidthValue(amount: width, relation: .greaterThanOrEqual)
        
        return constraint
    }
    
    // match the left anchor and width of another view
    public func constrainInsideLeftWidth(constrainInside: UIView) {
        self.prepForConstraints()
        
        self.doConstrainLeft(constrainTo: constrainInside)
        self.doConstrainWidth(constrainTo: constrainInside)
    }
    
    public func constrainInsideCenterWidth(constrainInside: UIView, multiplier: CGFloat=1.0) {
        self.prepForConstraints()
        
        self.doConstrainCenterX(constrainTo: constrainInside)
        self.doConstrainWidth(constrainTo: constrainInside, multiplier: multiplier)
    }
    
    // match width value
    public func constrainToWidth(constrainTo: UIView, amount: CGFloat=0.0, multiplier: CGFloat=1.0) -> NSLayoutConstraint {
        self.prepForConstraints()
        
        return self.doConstrainWidth(constrainTo: constrainTo, amount: amount, multiplier: multiplier)
    }
    
    // constant value
    public func constrainWidth(width: CGFloat, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        self.prepForConstraints()
        
        return self.doConstrainWidthValue(amount: width, relation: relation)
    }
    
    public func constrainWidthToParent(parent: UIView, percentage : CGFloat, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        self.prepForConstraints()
        
        return doConstrainWidth(constrainTo: parent, amount: 0, multiplier: percentage, relation: relation)
    }
    
    public func constrainHeightToParent(parent: UIView, percentage : CGFloat) -> NSLayoutConstraint {
        self.prepForConstraints()
        
        return doConstrainHeight(constrainTo: parent, amount: 0, multiplier: percentage)
    }
    
    // MARK: Height
    //
    
    public func constrainInsideRight(constrainInside: UIView, amount : CGFloat=0.0) {
        self.prepForConstraints()
        
        self.doConstrainRight(constrainTo: constrainInside, amount: amount)
    }
    
    // MARK: Height
    //
    
    public func constrainInsideRightHeight(constrainInside: UIView, multiplier: CGFloat=1.0) {
        self.prepForConstraints()
        
        self.doConstrainTop(constrainTo: constrainInside)
        self.doConstrainHeight(constrainTo: constrainInside, multiplier: multiplier)
    }
    
    public func constrainHeight(height: CGFloat, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        self.prepForConstraints()
        let constraint = self.doConstrainHeightValue(amount: height, relation: relation)
        
        return constraint
    }
    
    public func constrainHeightGreaterOrEqual(height: CGFloat) -> NSLayoutConstraint {
        self.prepForConstraints()
        let constraint = self.doConstrainHeightValue(amount: height, relation: .greaterThanOrEqual)
        
        return constraint
    }
    
    // match height value
    public func constrainToHeight(constrainTo: UIView, amount: CGFloat=0.0, multiplier: CGFloat=1.0) -> NSLayoutConstraint {
        self.prepForConstraints()
        
        return self.doConstrainHeight(constrainTo: constrainTo, amount: amount, multiplier: multiplier)
    }
    
    // match left value
    public func constrainToLeft(constrainTo: UIView, amount: CGFloat=0.0) -> NSLayoutConstraint {
        self.prepForConstraints()
        
        return self.doConstrainLeft(constrainTo: constrainTo, amount: amount)
    }
    
    // match right value
    public func constrainToRight(constrainTo: UIView, amount: CGFloat=0.0) -> NSLayoutConstraint {
        self.prepForConstraints()
        
        return self.doConstrainRight(constrainTo: constrainTo, amount: -amount)
    }
    
    // match top value
    public func constrainToTop(constrainTo: UIView, amount: CGFloat=0.0) -> NSLayoutConstraint {
        self.prepForConstraints()
        
        return self.doConstrainTop(constrainTo: constrainTo, amount: amount)
    }
    
    // match bottom value
    public func constrainToBottom(constrainTo: UIView, amount: CGFloat=0.0) -> NSLayoutConstraint {
        self.prepForConstraints()
        
        return self.doConstrainBottom(constrainTo: constrainTo, amount: amount)
    }
    
    // MARK: Inside parent edges
    //
    
    public func constrainInsideTop(constrainInside: UIView, amount: CGFloat) -> NSLayoutConstraint {
        self.prepForConstraints()
        
        return self.doConstrainTop(constrainTo: constrainInside, amount: amount)
    }
    
    public func constrainInsideBottom(constrainInside: UIView, amount: CGFloat) {
        self.prepForConstraints()
        
        self.doConstrainBottom(constrainTo: constrainInside, amount: amount)
    }
    
    public func constrainInsideTopLeft(constrainInside: UIView, amountX: CGFloat=0, amountY: CGFloat=0) {
        self.prepForConstraints()
        
        self.doConstrainTop(constrainTo: constrainInside, amount: amountY)
        self.doConstrainLeft(constrainTo: constrainInside, amount: amountX)
    }
    
    public func constrainInsideLeftCenter(constrainInside: UIView, amount: CGFloat) {
        self.prepForConstraints()
        
        self.doConstrainCenterY(constrainTo: constrainInside)
        self.doConstrainLeft(constrainTo: constrainInside, amount: amount)
    }
    
    public func constrainInsideTopCenter(constrainInside: UIView, amount: CGFloat) {
        self.prepForConstraints()
        
        self.doConstrainTop(constrainTo: constrainInside, amount: amount)
        self.doConstrainCenterX(constrainTo: constrainInside)
    }
    
    public func constrainInsideTopRight(constrainInside: UIView, amountX: CGFloat, amountY: CGFloat) {
        self.prepForConstraints()
        
        self.doConstrainTop(constrainTo: constrainInside, amount: amountY)
        self.doConstrainRight(constrainTo: constrainInside, amount: -amountX)
    }
    
    public func constrainInsideRightCenter(constrainInside: UIView, amount: CGFloat) {
        self.prepForConstraints()
        
        self.doConstrainCenterY(constrainTo: constrainInside)
        self.doConstrainRight(constrainTo: constrainInside, amount: -amount)
    }
    
    public func constrainInsideBottomLeft(constrainInside: UIView, amountX: CGFloat, amountY: CGFloat) {
        self.prepForConstraints()
        
        self.doConstrainBottom(constrainTo: constrainInside, amount: -amountY)
        self.doConstrainLeft(constrainTo: constrainInside, amount: amountX)
    }
    
    public func constrainInsideBottomRight(constrainInside: UIView, amountX: CGFloat, amountY: CGFloat) {
        self.prepForConstraints()
        
        self.doConstrainBottom(constrainTo: constrainInside, amount: -amountY)
        self.doConstrainRight(constrainTo: constrainInside, amount: -amountX)
    }
    
    public func constrainInsideBottomCenter(constrainInside: UIView, amount: CGFloat) {
        self.prepForConstraints()
        
        self.doConstrainBottom(constrainTo: constrainInside, amount: -amount)
        self.doConstrainCenterX(constrainTo: constrainInside)
    }
    
    // MARK: Attach to a sibling
    //
    
    // put left of a sibling
    public func constrainLeft(constrainTo: UIView, amount: CGFloat, offsetY: CGFloat=0.0) {
        self.prepForConstraints()
        
        self.doConstrainRightLeft(constrainTo: constrainTo, amount: -amount)
        self.doConstrainTop(constrainTo: constrainTo, amount: offsetY)
    }
    
    // put left of a sibling, and centered vertically
    public func constrainLeftCentered(constrainTo: UIView, amount: CGFloat=0.0) {
        self.prepForConstraints()
        
        self.doConstrainRightLeft(constrainTo: constrainTo, amount: -amount)
        self.doConstrainCenterY(constrainTo: constrainTo)
    }
    
    // put right of a sibling
    public func constrainRight(constrainTo: UIView, amount: CGFloat, offsetY: CGFloat=0.0) {
        self.prepForConstraints()
        
        self.doConstrainLeftRight(constrainTo: constrainTo, amount: amount)
        self.doConstrainTop(constrainTo: constrainTo, amount: offsetY)
    }
    
    // put right of a sibling, and centered vertically
    public func constrainRightCentered(constrainTo: UIView, amount: CGFloat=0.0) {
        self.prepForConstraints()
        
        self.doConstrainLeftRight(constrainTo: constrainTo, amount: amount)
        self.doConstrainCenterY(constrainTo: constrainTo)
    }
    
    // put above a sibling
    public func constrainAbove(constrainTo: UIView, amount: CGFloat=0.0) -> NSLayoutConstraint {
        self.prepForConstraints()
        
        return self.doConstrainBottomTop(constrainTo: constrainTo, amount: amount)
    }
    
    // put above a sibling, centered horizontally
    public func constrainAboveCentered(constrainTo: UIView, amount: CGFloat, centerReference: UIView?=nil, offsetX: CGFloat?=0.0) -> NSLayoutConstraint {
        self.prepForConstraints()
        
        var offX: CGFloat = 0.0
        
        if let ox = offsetX {
            offX = ox
        }
        
        if let ref = centerReference {
            self.doConstrainCenterX(constrainTo: ref, amount: offX)
        } else {
            self.doConstrainCenterX(constrainTo: constrainTo, amount: offX)
        }
        
        let topConstraint = self.doConstrainBottomTop(constrainTo: constrainTo, amount: -amount)
        
        return topConstraint
    }
    
    // put below a sibling
    public func constrainBelow(constrainTo: UIView, amount: CGFloat) -> NSLayoutConstraint {
        self.prepForConstraints()
        
        return self.doConstrainTopBottom(constrainTo: constrainTo, amount: amount)
    }
    
    // put below a sibling, centered horizontally
    public func constrainBelowCentered(constrainTo: UIView, amount: CGFloat, centerReference: UIView?=nil, offsetX: CGFloat?=0.0) {
        self.prepForConstraints()
        
        var offX: CGFloat = 0.0
        
        if let ox = offsetX {
            offX = ox
        }
        
        if let ref = centerReference {
            self.doConstrainCenterX(constrainTo: ref, amount: offX)
        } else {
            self.doConstrainCenterX(constrainTo: constrainTo, amount: offX)
        }
        
        self.doConstrainTopBottom(constrainTo: constrainTo, amount: amount)
    }
    
    // put below, aligned to the left side of the sibling
    public func constrainBelowLeft(constrainTo: UIView, amount: CGFloat, belowReference: UIView?=nil, offsetX: CGFloat?=0.0) {
        self.prepForConstraints()
        
        if let ref = belowReference {
            self.doConstrainTopBottom(constrainTo: ref, amount: amount)
        } else {
            self.doConstrainTopBottom(constrainTo: constrainTo, amount: amount)
        }
        
        if let offX = offsetX {
            self.doConstrainLeft(constrainTo: constrainTo, amount: offX)
        } else {
            self.doConstrainLeft(constrainTo: constrainTo)
        }
    }
    
    // put below, aligned to the right of the sibing
    public func constrainBelowRight(constrainTo: UIView, amount: CGFloat) {
        self.prepForConstraints()
        
        self.doConstrainRight(constrainTo: constrainTo)
        self.doConstrainTopBottom(constrainTo: constrainTo, amount: amount)
    }
    
    
    // MARK: - Private
    //
    
    private func prepForConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func doConstrainLeft(constrainTo: UIView, amount: CGFloat=0.0) -> NSLayoutConstraint {
        
        var constraint : NSLayoutConstraint
        if #available(iOS 9, *) {
            constraint = self.leftAnchor.constraint(equalTo: constrainTo.leftAnchor, constant: amount)
            constraint.isActive = true
        } else {
            constraint = self.doConstrainThis(constrainTo: constrainTo, amount: amount, attribute: .left)
        }
        
        return constraint
    }
    
    private func doConstrainRight(constrainTo: UIView, amount: CGFloat=0.0) -> NSLayoutConstraint {
        
        var constraint : NSLayoutConstraint
        
        if #available(iOS 9, *) {
            constraint = self.rightAnchor.constraint(equalTo: constrainTo.rightAnchor, constant: amount)
            constraint.isActive = true
        } else {
            constraint = self.doConstrainThis(constrainTo: constrainTo, amount: amount, attribute: .right)
        }
        
        return constraint
    }
    
    private func doConstrainTop(constrainTo: UIView, amount: CGFloat=0.0) -> NSLayoutConstraint {
        
        var constraint : NSLayoutConstraint
        
        if #available(iOS 9, *) {
            constraint = self.topAnchor.constraint(equalTo: constrainTo.topAnchor, constant: amount)
            constraint.isActive = true
        } else {
            constraint = self.doConstrainThis(constrainTo: constrainTo, amount: amount, attribute: .top)
        }
        
        return constraint
    }
    
    private func doConstrainBottom(constrainTo: UIView, amount: CGFloat=0.0) -> NSLayoutConstraint {
        
        var constraint : NSLayoutConstraint
        
        if #available(iOS 9, *) {
            constraint = self.bottomAnchor.constraint(equalTo: constrainTo.bottomAnchor, constant: amount)
            constraint.isActive = true
        } else {
            constraint = self.doConstrainThis(constrainTo: constrainTo, amount: amount, attribute: .bottom)
        }
        
        return constraint
    }
    
    private func doConstrainWidth(constrainTo: UIView, amount: CGFloat=0.0, multiplier: CGFloat=1.0, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint
        
        if #available(iOS 9, *) {
            
            if relation == .equal {
                constraint = self.widthAnchor.constraint(equalTo: constrainTo.widthAnchor, multiplier: multiplier, constant: amount)
            } else if relation == .greaterThanOrEqual {
                constraint = self.widthAnchor.constraint(greaterThanOrEqualTo: constrainTo.widthAnchor, multiplier: multiplier, constant: amount)
            } else  {
                constraint = self.widthAnchor.constraint(lessThanOrEqualTo: constrainTo.widthAnchor, multiplier: multiplier, constant: amount)
            }
            
            
            constraint.isActive = true
        } else {
            constraint = self.doConstrainThis(constrainTo: constrainTo, amount: amount, attribute: .width, multiplier: multiplier)
        }
        
        return constraint
    }
    
    private func doConstrainWidthValue(amount: CGFloat=0.0, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint
        
        if #available(iOS 9, *) {
            
            if relation == .equal {
                constraint = self.widthAnchor.constraint(equalToConstant: amount)
            } else if relation == .greaterThanOrEqual {
                constraint = self.widthAnchor.constraint(greaterThanOrEqualToConstant: amount)
            } else {
                constraint = self.widthAnchor.constraint(lessThanOrEqualToConstant: amount)
            }
            
            constraint.isActive = true
        } else {
            constraint = self.doConstrainThisValue(amount: amount, attribute: .width, relation: relation)
        }
        
        return constraint
    }
    
    private func doConstrainHeight(constrainTo: UIView, amount: CGFloat=0.0, multiplier: CGFloat=1.0) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint
        
        if #available(iOS 9, *) {
            constraint = self.heightAnchor.constraint(equalTo: constrainTo.heightAnchor, multiplier: multiplier, constant: amount)
            
            constraint.isActive = true
        } else {
            constraint = self.doConstrainThis(constrainTo: constrainTo, amount: amount, attribute: .height, multiplier: multiplier)
        }
        
        return constraint
    }
    
    private func doConstrainHeightValue(amount: CGFloat=0.0, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint
        
        if #available(iOS 9, *) {
            if relation == .equal {
                constraint = self.heightAnchor.constraint(equalToConstant: amount)
            } else if relation == .greaterThanOrEqual {
                constraint = self.heightAnchor.constraint(greaterThanOrEqualToConstant: amount)
            } else {
                constraint = self.heightAnchor.constraint(lessThanOrEqualToConstant: amount)
            }
            
            constraint.isActive = true
        } else {
            constraint = self.doConstrainThisValue(amount: amount, attribute: .height, relation: relation)
        }
        
        return constraint
    }
    
    private func doConstrainCenterX(constrainTo: UIView, amount: CGFloat=0.0) {
        if #available(iOS 9, *) {
            self.centerXAnchor.constraint(equalTo: constrainTo.centerXAnchor, constant: amount).isActive = true
        } else {
            self.doConstrainThis(constrainTo: constrainTo, amount: amount, attribute: .centerX)
        }
    }
    
    private func doConstrainCenterY(constrainTo: UIView, amount: CGFloat=0.0) -> NSLayoutConstraint {
        if #available(iOS 9, *) {
            let constraint = self.centerYAnchor.constraint(equalTo: constrainTo.centerYAnchor, constant: amount)
            constraint.isActive = true
            return constraint
        } else {
            return self.doConstrainThis(constrainTo: constrainTo, amount: amount, attribute: .centerY)
        }
    }
    
    private func doConstrainLeftRight(constrainTo: UIView, amount: CGFloat=0.0) -> NSLayoutConstraint {
        var constraint : NSLayoutConstraint
        if #available(iOS 9, *) {
            constraint = self.leftAnchor.constraint(equalTo: constrainTo.rightAnchor, constant: amount)
            constraint.isActive = true
        } else {
            constraint = self.doConstrainThisToThis(constrainTo: constrainTo, amount: amount, attribute: .left, toAttribute: .right)
        }
        
        return constraint
    }
    
    private func doConstrainRightLeft(constrainTo: UIView, amount: CGFloat=0.0) {
        if #available(iOS 9, *) {
            self.rightAnchor.constraint(equalTo: constrainTo.leftAnchor, constant: amount).isActive = true
        } else {
            self.doConstrainThisToThis(constrainTo: constrainTo, amount: amount, attribute: .right, toAttribute: .left)
        }
    }
    
    private func doConstrainTopBottom(constrainTo: UIView, amount: CGFloat=0.0) -> NSLayoutConstraint {
        
        var constraint: NSLayoutConstraint
        
        if #available(iOS 9, *) {
            constraint = self.topAnchor.constraint(equalTo: constrainTo.bottomAnchor, constant: amount)
            constraint.isActive = true
        } else {
            constraint = self.doConstrainThisToThis(constrainTo: constrainTo, amount: amount, attribute: .top, toAttribute: .bottom)
        }
        
        return constraint
    }
    
    private func doConstrainBottomTop(constrainTo: UIView, amount: CGFloat=0.0) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint
        
        if #available(iOS 9, *) {
            constraint = self.bottomAnchor.constraint(equalTo: constrainTo.topAnchor, constant: amount)
            
            constraint.isActive = true
        } else {
            constraint = self.doConstrainThisToThis(constrainTo: constrainTo, amount: amount, attribute: .bottom, toAttribute: .top)
        }
        
        return constraint
    }
    
    // iOS 8.0 and previous - convenience
    //
    private func doConstrainThis(constrainTo: UIView, amount: CGFloat, attribute: NSLayoutAttribute, multiplier: CGFloat=1.0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: NSLayoutRelation.equal, toItem: constrainTo, attribute: attribute, multiplier: multiplier, constant: amount)
        self.superview!.addConstraint(constraint)
        
        return constraint
    }
    
    private func doConstrainThisValue(amount: CGFloat, attribute: NSLayoutAttribute, relation : NSLayoutRelation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: amount)
        self.addConstraint(constraint)
        
        return constraint
    }
    
    private func doConstrainAspect(amount: CGFloat) -> NSLayoutConstraint {
        
        let constraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: .height, multiplier: amount, constant: 0)
        self.addConstraint(constraint)
        
        return constraint
    }
    
    private func doConstrainThisToThis(constrainTo: UIView, amount: CGFloat, attribute: NSLayoutAttribute, toAttribute: NSLayoutAttribute) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: NSLayoutRelation.equal, toItem: constrainTo, attribute: toAttribute, multiplier: 1, constant: amount)
        self.superview!.addConstraint(constraint)
        
        return constraint
    }
}
