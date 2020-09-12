//
//  AuthorizationNetwork.swift
//  iOSDepartment
//
//  Created by Строев Александр on 11.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

import Foundation

class AuthorizationNetwork: NSObject, AuthorizationNetworkProtocol {
    func authorizationRequest(login: String, password: String) -> API.TestAPI {
        return API.TestAPI(requestData: EmptyRequest())
    }
}
