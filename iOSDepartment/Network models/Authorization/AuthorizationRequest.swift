//
//  AuthorizationRequest.swift
//  iOSDepartment
//
//  Created by Александр Строев on 16.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

struct AuthorizationRequest: Encodable {
    let login: String
    let password: String
}
