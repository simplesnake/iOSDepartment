//
//  AuthorizationInteractorOutput.swift
//  iOSDepartment
//
//  Created by Александр Строев on 07.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

protocol AuthorizationInteractorOutput: BaseInteractorOutput {
    func authorizationSuccess()
    func authorizationDenied()
}

extension AuthorizationPresenter: AuthorizationInteractorOutput {
    
    func authorizationSuccess() {
        print("Success!")
    }
    
    func authorizationDenied() {
        view.authorizationDenied()
    }
    
}
