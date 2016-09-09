//
//  RadialTabBarController.swift
//  RadialTabBar
//
//  Created by Kurt Jensen on 9/9/16.
//  Copyright © 2016 Example. All rights reserved.
//

import UIKit

class RadialTabBarController: UITabBarController {
    
    private (set) var isShowingRadial = false {
        didSet {
            radialToggleButton.selected = isShowingRadial
        }
    }
    private (set) var radialButtons: [RadialTabBarButton] = []
    private (set) var radialToggleButton: RadialTabBarButton!
    private var tapGesture: UITapGestureRecognizer?
    private var tintColor: UIColor = UIColor.blackColor()

    private let padding: CGFloat = 8
    private let buttonSide: CGFloat = 44
    private let diameter: CGFloat = 240
    private var startingPoint: CGPoint {
        return CGPointMake((view.frame.width-diameter)/2, view.frame.height-buttonSide*2)
    }
    private var radius: Double {
        return Double(self.diameter/2)
    }
    private let maxAngle: Double = 330
    private let minAngle: Double = 210

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupButtons()
    }
    
    private func setupView() {
        tabBar.hidden = true
        radialToggleButton = RadialTabBarButton(title: nil, image: nil, tintColor: tintColor)
        radialToggleButton.setTitle("X", forState: .Selected)
        radialToggleButton.addTarget(self, action: #selector(RadialTabBarController.showRadialTapped(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(radialToggleButton)
        radialToggleButton.translatesAutoresizingMaskIntoConstraints = false
        let sideConstraint = NSLayoutConstraint(item: radialToggleButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: buttonSide)
        let ratioConstraint = NSLayoutConstraint(item: radialToggleButton, attribute: .Width, relatedBy: .Equal, toItem: radialToggleButton, attribute: .Height, multiplier: 1, constant: 0)
        let horizontalConstraint = NSLayoutConstraint(item: radialToggleButton, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: radialToggleButton, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: -padding)
        view.addConstraints([sideConstraint, ratioConstraint, horizontalConstraint, bottomConstraint])
    }
    
    override func setViewControllers(viewControllers: [UIViewController]?, animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        setupButtons()
    }

    private func resetButtons() {
        for button in radialButtons {
            button.removeFromSuperview()
        }
        hideRadial()
    }
    
    private func setupButtons() {
        resetButtons()
        for viewController in viewControllers ?? [] {
            let tabBarItem = viewController.tabBarItem
            let radialButton = RadialTabBarButton(title: tabBarItem.title, image: tabBarItem.image, tintColor: tintColor)
            radialButton.addTarget(self, action: #selector(RadialTabBarController.radialButtonTapped(_:)), forControlEvents: .TouchUpInside)
            radialButtons.append(radialButton)
            view.addSubview(radialButton)
        }
    }
    
    func showRadialTapped(sender: AnyObject) {
        if (isShowingRadial) {
            hideRadial()
        } else {
            showRadial()
        }
    }
    
    func radialButtonTapped(sender: RadialTabBarButton) {
        guard let index = radialButtons.indexOf(sender) else {
            return
        }
        selectedIndex = index
        hideRadial()
    }
    
    func viewTapped(tapGesture: UITapGestureRecognizer) {
        switch tapGesture.state {
        case .Ended:
            hideRadial()
        default:
            break
        }
    }
    
    private func showRadial() {
        guard isShowingRadial == false else {
            return
        }
        isShowingRadial = true
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(RadialTabBarController.viewTapped(_:)))
        view.addGestureRecognizer(tapGesture!)
        for button in radialButtons {
            button.frame = radialToggleButton.frame
            button.alpha = 0
            button.hidden = false
        }
        UIView.animateWithDuration(0.25, animations: {
            var index = 0
            for button in self.radialButtons {
                let translation = button.radialTranslation(index, max: self.radialButtons.count-1, radius: self.radius, maxAngle: self.maxAngle, minAngle: self.minAngle)
                var center = self.startingPoint
                center.x += translation.x
                center.y += translation.y
                button.center = center
                button.alpha = 1
                index += 1
            }
        }) { (completed) in
        }
    }
    
    private func hideRadial() {
        guard isShowingRadial == true else {
            return
        }
        isShowingRadial = false
        if let tapGesture = tapGesture where view.gestureRecognizers?.contains(tapGesture) == true {
            view.removeGestureRecognizer(tapGesture)
        }
        UIView.animateWithDuration(0.25, animations: {
            for button in self.radialButtons {
                button.frame = self.radialToggleButton.frame
                button.alpha = 0
            }
        }) { (completed) in
            for button in self.radialButtons {
                button.hidden = true
            }
        }
    }
}
