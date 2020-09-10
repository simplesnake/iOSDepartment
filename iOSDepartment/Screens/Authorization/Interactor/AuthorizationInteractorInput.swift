//
//  AuthorizationInteractorInput.swift
//  iOSDepartment
//
//  Created by Александр Строев on 07.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

protocol AuthorizationInteractorInput: BaseInteractorInput {
    var title: Int { get }
}

extension AuthorizationInteractor: AuthorizationInteractorInput {
    var title: Int {
        data.q
    }
}
