//
//  AuthorizationPresenter.swift
//  iOSDepartment
//
//  Created by Александр Строев on 07.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

class AuthorizationPresenter: BasePresenter {
    var view: AuthorizationViewInput!
    var interactor: AuthorizationInteractorInput!
    weak var router: AuthorizationRouter!
}
