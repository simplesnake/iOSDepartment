//
//  UIViewController+Extensions.swift
//  iOSDepartment
//
//  Created by Александр Строев on 26.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

import UIKit

extension UIViewController {
    
    class func controller() -> Self {
        let classReference = self.self
        return classReference.init(nibName: nibName, bundle: nil)
    }
    
    var isModal: Bool {
        return presentingViewController != nil ||
            navigationController?.presentingViewController?.presentedViewController === navigationController ||
            tabBarController?.presentingViewController is UITabBarController
    }
    
    var isVisible: Bool {
        if isViewLoaded {
            return view.window != nil
        }
        return false
    }
    
    var isTopViewController: Bool {
        if self.navigationController != nil {
            return self.navigationController?.visibleViewController === self
        } else if self.tabBarController != nil {
            return self.tabBarController?.selectedViewController == self && self.presentedViewController == nil
        } else {
            return self.presentedViewController == nil && self.isVisible
        }
    }
    
    private class var nibName: String {
        let className = String(describing: self)
        let index = className.firstIndex(of: "<") ?? className.endIndex
        
        return String(className[..<index])
    }
    
    private class func _instantiate<Controller: UIViewController>(from storyboard: UIStoryboard) -> Controller {
        
        guard let result = storyboard.instantiateViewController(withIdentifier: nibName) as? Controller else {
            let className = (String(describing: Controller.self))
            fatalError("No controller of \(className) class with \"\(nibName)\" identifier in storyboard")
        }
        
        return result
    }
    
    class func instantiate(from storyboard: UIStoryboard) -> Self {
        return _instantiate(from: storyboard)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    

}


