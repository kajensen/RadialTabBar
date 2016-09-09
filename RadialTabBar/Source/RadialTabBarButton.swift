//
//  RadialTabBarButton.swift
//  RadialTabBar
//
//  Created by Kurt Jensen on 9/9/16.
//  Copyright © 2016 Example. All rights reserved.
//

import UIKit

class RadialTabBarButton: UIButton {
    
    class func degreesToRadians(degrees:Double) -> Double {
        return degrees * M_PI / 180
    }
    
    class func getAngleForIndex(idx: Int, max: Int, maxAngle: Double, minAngle: Double) -> Double {
        let spreadAngle = maxAngle - minAngle
        let percentage = Double(idx) / Double(max)
        let angle = degreesToRadians(minAngle + (percentage * spreadAngle))
        return angle
    }
    
    class func getPointForAngle(angle: Double, radius: Double) -> CGPoint {
        let pointX = CGFloat(radius * cos(angle) + radius)
        let pointY = CGFloat(radius * sin(angle) + radius)
        return CGPoint(x: pointX, y: pointY)
    }
    
    convenience init(title: String?, image: UIImage?, tintColor: UIColor) {
        self.init()
        setTitle(title, forState: .Normal)
        setImage(image, forState: .Normal)
        setTitleColor(tintColor, forState: .Normal)
        self.tintColor = tintColor
        layer.borderWidth = 1
        layer.borderColor = tintColor.CGColor
        backgroundColor = UIColor.whiteColor()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.width,bounds.height)/2
    }
    
    func radialTranslation(index: Int, max: Int, radius: Double, maxAngle: Double, minAngle: Double) -> CGPoint {
        let angle = RadialTabBarButton.getAngleForIndex(index, max: max, maxAngle: maxAngle, minAngle: minAngle)
        return RadialTabBarButton.getPointForAngle(angle, radius: radius)
    }
    
}