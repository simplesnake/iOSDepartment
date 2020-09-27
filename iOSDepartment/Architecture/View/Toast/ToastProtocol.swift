//
//  ToastProtocol.swift
//  iOSDepartment
//
//  Created by Александр Строев on 27.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

import Foundation

protocol ToastProtocol: NSObject {
    func showToast(_ message: String)
}

extension ToastProtocol where Self: BaseViewController {
    
    func showToast(_ message: String) {
        print("showToast \(message)")
    }
    
}
