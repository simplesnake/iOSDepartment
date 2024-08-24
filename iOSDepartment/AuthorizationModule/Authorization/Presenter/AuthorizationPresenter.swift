//
//  AuthorizationPresenter.swift
//  iOSDepartment
//
//  Created by Fox on 24.08.2024.
//  Copyright © 2024 Stroev. All rights reserved.
//

import Foundation


class AuthorizationPresenter: BasePresenter {
    
    weak var view: AuthorizationViewInput!
    var interactor: AuthorizationInteractorInput!
    var router: AuthorizationRouter!
    var localization: AuthorizationLocalization!
}
