//
//  LoaderViewProtocol.swift
//  iOSDepartment
//
//  Created by Александр Строев on 27.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

import Foundation
import UIKit

protocol LoaderViewProtocol {
    var view: UIView! { get }
    
    func startAnimation()
    func removeLoader()
    
    func showLoader(_ parent: UIView)
    func hideLoader(_ parent: UIView)
}
