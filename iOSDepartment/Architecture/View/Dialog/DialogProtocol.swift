//
//  DialogProtocol.swift
//  iOSDepartment
//
//  Created by Александр Строев on 18.06.2021.
//  Copyright © 2021 Stroev. All rights reserved.
//

import UIKit

protocol DialogProtocol: NSObject {
    func showOkDialog(message: String, onOkTap: (()->())?)
    func showYesNoDialog(message: String, onYesTap: (()->())?, onNoTap: (()->())?)
}

extension DialogProtocol where Self: BaseViewController {
    
    func showOkDialog(message: String, onOkTap: (()->())?) {
        guard !view.isHidden && view.window != nil else {
            return
        }
        
        let dialog = OkDialog(message: message, onOkTap: onOkTap)
        let isNavigationBarHidden = self.navigationController?.navigationBar.isHidden ?? true
        dialog.shadow = UIView()
        dialog.shadow?.backgroundColor = appearance.colors.dark_main
        dialog.shadow?.alpha = 0.0
        let superView = isNavigationBarHidden ? self.view : self.navigationController?.view
        if let shadow = dialog.shadow {
            view.addSubview(shadow)
        }
        view.addSubview(dialog)
        dialog.shadow?.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }
        dialog.snp.makeConstraints{ make in
            make.left.right.equalToSuperview().inset(10)
            make.center.equalToSuperview()
            
        }
        dialog.alpha = 0.0
        
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
    func showYesNoDialog(message: String, onYesTap: (()->())?, onNoTap: (()->())?){
        guard !view.isHidden && view.window != nil else {
            return
        }

        let dialog = YesNoDialog(message: message, onYesTap: onYesTap, onNoTap: onNoTap)
        let isNavigationBarHidden = self.navigationController?.navigationBar.isHidden ?? true
        dialog.shadow = UIView()
        dialog.shadow?.backgroundColor = appearance.colors.dark_main
        dialog.shadow?.alpha = 0.0
        let superView = isNavigationBarHidden ? self.view : self.navigationController?.view
        if let shadow = dialog.shadow {
            view.addSubview(shadow)
        }
        view.addSubview(dialog)
        dialog.shadow?.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }
        dialog.snp.makeConstraints{ make in
            make.left.right.equalToSuperview().inset(10)
            make.center.equalToSuperview()
            
        }
        dialog.alpha = 0.0
        
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

