//
//  BaseLocalization.swift
//  iOSDepartment
//
//  Created by Александр Строев on 07.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

import Foundation

class BaseLocalization: NSObject {
    func localize(_ id: String) -> String {
        return id.localize(className)
    }
}
