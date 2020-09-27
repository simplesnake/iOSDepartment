//
//  BaseInteractorOutput.swift
//  iOSDepartment
//
//  Created by Александр Строев on 07.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

import Foundation

protocol BaseInteractorOutput: NSObject {
    var screenUtilities: (LoaderProtocol & ToastProtocol)? { get }
}
