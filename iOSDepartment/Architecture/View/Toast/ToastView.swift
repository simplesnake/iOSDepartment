//
//  ToastView.swift
//  iOSDepartment
//
//  Created by Александр Строев on 27.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

import UIKit

final class ToastView: UIView {
    
    @IBOutlet var background: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var text: String? {
        get {
            return self.messageLabel.text
        }
        
        set(text) {
            self.messageLabel.text = text ?? ""
        }
    }
    
//    static func toastView(_ message: String) -> ToastView {
//        let toast: ToastView = ToastView().loadNib()
//        toast.text = message
//
//        return toast
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        background.corners(radius: 10)
    }
    
    
    class Timings {
        static let enter: TimeInterval = 0.2
        static let waiting: TimeInterval = 3
        static let exit: TimeInterval = 0.5
    }
}

