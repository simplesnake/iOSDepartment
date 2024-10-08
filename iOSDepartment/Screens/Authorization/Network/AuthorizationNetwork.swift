//
//  AuthorizationNetwork.swift
//  iOSDepartment
//
//  Created by Строев Александр on 11.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

class AuthorizationNetwork: BaseNetwork {
    func authorization(_ model: API.Authorization.Model) {
        API.Authorization(model).request()
    }
}
