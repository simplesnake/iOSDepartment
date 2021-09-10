//
//  KeyboardSensitiveConstraints.swift
//  MediaApp
//
//  Created by Строев Александр on 13.01.2020.
//  Copyright © 2020 Строев Александр. All rights reserved.
//

import UIKit

class KeyboardSensitiveConstraints {
    
    private let keyboardService: KeyboardService = KeyboardService()
    private var view: UIView
    private var constraints: [NSLayoutConstraint] = []
    
    init(view: UIView) {
        self.view = view
        keyboardService.onChangeHeight{ [weak self] height in
            guard let self = self else { return }
//            anim(constraintParent: self.view){ setting -> VoidCompletion in
//                setting.ease = .easeOutCirc
//                setting.duration = 0.1
//                return {
//                    self.constraints.forEach({
//                        [weak self] constraint in
//                        if let newConstant = self?.getConstraintConstant(height: height, constraint: constraint) {
//                            constraint.constant = newConstant
//                        }
//                    })
//                }
//            }
            self.constraints.forEach({
                [weak self] constraint in
                if let newConstant = self?.getConstraintConstant(height: height, constraint: constraint) {
                    constraint.constant = newConstant
                }
            })
            UIView.animate(withDuration: 0.1, animations: {
                self.view.layoutIfNeeded()
            }, completion: { complete in
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func setRootView(view: UIView) {
        self.view = view
    }
    
    func addConstraint(constraint: NSLayoutConstraint) {
        constraints.append(constraint)
    }
    
    private func getConstraintConstant(height: CGFloat, constraint: NSLayoutConstraint) -> CGFloat {
        return height > 0 ? height - 40 : 0
    }
}

