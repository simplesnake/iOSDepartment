//
//  Appearance.swift
//  iOSDepartment
//
//  Created by Александр Строев on 10.09.2021.
//  Copyright © 2021 Stroev. All rights reserved.
//

class Appearance {
    
    static let sharedInstance: Appearance = Appearance()
    
    private init() {}
    
    let colors = AppearanceColors()
    let fonts = AppearanceFonts()
}
