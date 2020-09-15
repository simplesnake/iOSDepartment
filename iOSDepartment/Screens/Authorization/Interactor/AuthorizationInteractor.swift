//
//  AuthorizationInteractor.swift
//  iOSDepartment
//
//  Created by Александр Строев on 07.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

class AuthorizationInteractor: BaseInteractor<AuthorizationData> {
    
    weak var presenter: AuthorizationInteractorOutput!
    weak var network: AuthorizationNetwork!
    
    func authorization(login: String, password: String) {
        network.authorization(API.Authorization.Model(requestData: AuthorizationRequest(login: login, password: password)))
    }
}
