//
//  BaseRouter.swift
//  iOSDepartment
//
//  Created by Александр Строев on 07.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

import UIKit

class BaseRouter: NSObject {
    
    weak var navigation: NavigationProtocol!
    
    init(_ navigation: NavigationProtocol) {
        self.navigation = navigation
    }
    
    func back(over: Int = 0, complition: (() -> ())? = nil) {
        removePreviousScreens(over)
        navigation.dismissOrPop(animated: true, complition)
    }
    
    func open(viewController: UIViewController, removeCurrent: Bool = false, _ completion: (() -> ())? = nil) {
        navigation.presentOrPush(viewController: viewController, removeCurrent: removeCurrent, animated: true, completion)
    }
    
    func removeFromStack(_ position: Int) {
        if let topViewController = navigation.topViewController {
            guard let count = topViewController.navigationController?.viewControllers.count, count > position else {
                return
            }
            topViewController.navigationController?.viewControllers.remove(at: position)
        }
    }
    
    func removePreviousScreens(_ count: Int) {
        for _ in 0..<count {
            removePreviousScreen()
        }
    }
    
    func removePreviousScreen() {
        guard let topViewController = navigation.topViewController, let count = topViewController.navigationController?.viewControllers.count else {
            return
        }
        topViewController.navigationController?.viewControllers.remove(at: count - 2)
    }
    
}
