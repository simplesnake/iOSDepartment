//
//  UIView+Extensions.swift
//  iOSDepartment
//
//  Created by Александр Строев on 27.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

import UIKit


// MARK: - Работа с анимациями
extension UIView {
    
    private static let kRotationAnimationKey = "rotationanimationkey"
    
    func rotate360(roundDuration: Double = 1, times: Float = Float.infinity) {
        if layer.animation(forKey: UIView.kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = roundDuration
            rotationAnimation.repeatCount = times
            
            layer.add(rotationAnimation, forKey: UIView.kRotationAnimationKey)
        }
    }
    
    func stopRotating() {
        if layer.animation(forKey: UIView.kRotationAnimationKey) != nil {
            layer.removeAnimation(forKey: UIView.kRotationAnimationKey)
        }
    }
    
    var appearance: Appearance {
        return Appearance.sharedInstance
    }
    
    var constraintHeight: NSLayoutConstraint {
        get {
            if let constraint = constraints.first(where: {
                $0.firstAttribute == .height && $0.relation == .equal
            }) {
                return constraint
            }
            
            let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: frame.height)
            addConstraint(constraint)
            
            return constraint
        }
        set { setNeedsLayout() }
    }
    
    var constraintBottomBottom: NSLayoutConstraint? {
        if let constraint = constraints.first(where: {
            $0.firstAttribute == .bottom && $0.relation == .equal && $0.secondAttribute == .bottom
        }) {
            return constraint
        }
        return nil
    }
    
    
    func addSubviews(_ view: UIView...) {
        view.forEach {
            self.addSubview($0)
        }
    }
}
