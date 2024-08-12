//
//  BaseDialog.swift
//  iOSDepartment
//
//  Created by Fox on 12.08.2024.
//  Copyright © 2024 Stroev. All rights reserved.
//

import Foundation
import UIKit

//Пример кастомного диалога
class BaseDialog: UIView {
    
    
    var shadow: UIView?
    
    func configure(view: UIViewController, customShadow: UIView? = nil){
        if let shadow = customShadow {
            self.shadow = customShadow
        } else {
            let defaultShadow = UIView()
            shadow = defaultShadow
            shadow?.backgroundColor = appearance.colors.dark_main
        }
        shadow?.alpha = 0.0
        
        
        if let shadow = shadow {
            view.view.addSubview(shadow)
        }
        view.view.addSubview(self)
        
        shadow?.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }
        snp.makeConstraints{ make in
            make.left.right.equalToSuperview().inset(10)
            make.center.equalToSuperview()
            
        }
        alpha = 0.0
    }

    func remove(){
        UIView.animate(withDuration: 0.1, animations:  {
            self.shadow?.alpha = 0
            self.alpha = 0
        }, completion: { _ in
        self.removeFromSuperview()
        self.shadow?.removeFromSuperview()
        })
    }
    
    init(){
        super.init(frame: CGRect())
       
        
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

