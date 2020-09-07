//
//  AuthorizationViewController.swift
//  iOSDepartment
//
//  Created by Александр Строев on 07.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

import UIKit

class AuthorizationViewController: BaseViewController, AuthorizationViewInput {
    
    weak var localization: AuthorizationLocalization!
    weak var presenter: AuthorizationViewOutput!
}
