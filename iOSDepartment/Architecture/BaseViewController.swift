//
//  BaseViewController.swift
//  iOSDepartment
//
//  Created by Александр Строев on 07.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    func loader(_ show: Bool) {
        print("Loder: \(show)")
    }
    
    func showToast(_ text: String) {
        print("Toast: \(text)")
    }
}
