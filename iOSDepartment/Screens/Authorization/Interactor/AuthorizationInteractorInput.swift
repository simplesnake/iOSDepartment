//
//  AuthorizationInteractorInput.swift
//  iOSDepartment
//
//  Created by Александр Строев on 07.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

protocol AuthorizationInteractorInput: BaseInteractorInput {
    func authorization(login: String, password: String)
}

extension AuthorizationInteractor: AuthorizationInteractorInput {
    func authorization(login: String, password: String) {
        network.authorization(API.Authorization.Model(
            requestData: AuthorizationRequest(login: login, password: password),
            onSuccess: {
                [weak self] data in
                guard let self = self else { return }
                self.storageManager.token = data.token!
                self.presenter.authorizationSuccess()
            }, onError: {
                [weak self] code, error in
                guard let self = self else { return }
                self.presenter.authorizationDenied()
            }
        ))
    }
}
