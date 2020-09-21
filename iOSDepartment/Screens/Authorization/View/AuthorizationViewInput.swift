//
//  AuthorizationViewInput.swift
//  iOSDepartment
//
//  Created by Александр Строев on 07.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

protocol AuthorizationViewInput: BaseViewInput {
    func authorizationDenied()
}

extension AuthorizationViewController: AuthorizationViewInput {
    func authorizationDenied() {
        print("AuthorizationViewController")
        print("Authorization denied!")
    }
}
