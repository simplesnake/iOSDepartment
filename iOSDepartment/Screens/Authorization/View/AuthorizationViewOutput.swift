//
//  AuthorizationViewOutput.swift
//  iOSDepartment
//
//  Created by Александр Строев on 07.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

protocol AuthorizationViewOutput: BaseViewOutput {
    func authorizationButtonTap(login: String, password: String)
}

extension AuthorizationPresenter: AuthorizationViewOutput {
    func authorizationButtonTap(login: String, password: String) {
        interactor.authorization(login: login, password: password)
    }
}
