//
//  DialogProtocol.swift
//  iOSDepartment
//
//  Created by Александр Строев on 18.06.2021.
//  Copyright © 2021 Stroev. All rights reserved.
//

import UIKit

protocol DialogProtocol: NSObject {
    
    func showDialog(dialog: BaseDialog)
}

extension DialogProtocol where Self: BaseViewController {
    
    func showDialog(dialog: BaseDialog) {
        guard !view.isHidden && view.window != nil else {
            return
        }
        
        
        let isNavigationBarHidden = self.navigationController?.navigationBar.isHidden ?? true
        
        let superView = isNavigationBarHidden ? self.view : self.navigationController?.view
        
        
        dialog.configure(view: self)
        superView?.layoutIfNeeded()
        superView?.layoutSubviews()
        dialog.layoutIfNeeded()

        
        UIView.animate(withDuration: 0.1) {
            dialog.snp.remakeConstraints{ make in
                make.center.equalToSuperview()
                make.left.right.equalToSuperview().inset(10)
                
            }
            dialog.shadow?.alpha = 0.5
            dialog.alpha = 1
            superView?.layoutIfNeeded()
            superView?.layoutSubviews()
        }
    }
    
    
    
}

