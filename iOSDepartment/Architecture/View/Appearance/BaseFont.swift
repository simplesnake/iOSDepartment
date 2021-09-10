//
//  BaseFont.swift
//  iOSDepartment
//
//  Created by Александр Строев on 10.09.2021.
//  Copyright © 2021 Stroev. All rights reserved.
//

import UIKit

protocol BaseFontProtocol {
    var name: String { get }
}

extension BaseFontProtocol {
    func get(style: BaseFontStyle = .regular,  size: CGFloat = 15) -> UIFont {
        return UIFont(name: "\(String(describing: name))\(style.value)", size: size)!
    }
}

enum BaseFontStyle: String {// можно дополнять по мере необходимости
    case regular, medium, bold, light, black, thin, italic, mediumItalic, boldItalic, lightItalic, blackItalic, thinItalic
    
    var value: String {
        return rawValue.firstCapitalized
    }
}
