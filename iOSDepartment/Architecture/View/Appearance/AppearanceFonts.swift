//
//  AppearanceFonts.swift
//  iOSDepartment
//
//  Created by Александр Строев on 10.09.2021.
//  Copyright © 2021 Stroev. All rights reserved.
//

import UIKit

struct AppearanceFonts {
    //Примеры
    let bigLabelFontExample = BaseFont().get(.medium, 24)
    let regularButtonFontExample = BaseFont().get(.black, 18)
}

class BaseFont: BaseFontProtocol {
    var name: String = UIFont.systemFont(ofSize: 15, weight: .regular).fontName
}
