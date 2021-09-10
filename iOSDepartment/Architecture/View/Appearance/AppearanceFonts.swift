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
    let bigLabelFontExample = TestFont().get(style: .medium, size: 24)
    let regularButtonFontExample = TestFont().get(style: .black, size: 18)
}

class TestFont: BaseFontProtocol {
    var name: String = UIFont.systemFont(ofSize: 15, weight: .regular).fontName
}
