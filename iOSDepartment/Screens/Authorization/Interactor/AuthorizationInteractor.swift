//
//  AuthorizationInteractor.swift
//  iOSDepartment
//
//  Created by Александр Строев on 07.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

class AuthorizationInteractor: BaseInteractor, AuthorizationInteractorInput {//}, AuthorizationInteractorData {
    
    weak var presenter: AuthorizationInteractorOutput!
}

// TODO Спорный момент
protocol AuthorizationInteractorData {
    var test: Int { get set }
    var qwer: String { get set }
}
