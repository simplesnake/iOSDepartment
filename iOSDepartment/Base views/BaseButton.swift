//
//  BaseButton.swift
//  iOSDepartment
//
//  Created by Александр Строев on 20.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

import UIKit

class BaseButton: UIButton {
    
    var underline: Bool = false {
        didSet {
            let attributedString = NSMutableAttributedString(string:"")
            if underline {
                let attrs = [NSAttributedString.Key.underlineStyle : 1,
                             NSAttributedString.Key.foregroundColor : titleColor(for: .normal) ?? UIColor.black] as [NSAttributedString.Key : Any]
                let buttonTitleStr = NSMutableAttributedString(string: title(for: .normal) ?? "", attributes:attrs)
                attributedString.append(buttonTitleStr)
            }
            setAttributedTitle(attributedString, for: .normal)
        }
    }
    
    var onTap: ((BaseButton) -> ())? {
        didSet {
            removeTarget(self, action: #selector(onTapHandler), for: .touchUpInside)
            addTarget(self, action: #selector(onTapHandler), for: .touchUpInside)
            isUserInteractionEnabled = true
        }
    }
    
    @objc final func onTapHandler() {
        onTap?(self)
    }
    
    var text: String {
        set { setTitle(newValue, for: .normal) }
        get { return title(for: .normal) ?? "" }
    }
}

