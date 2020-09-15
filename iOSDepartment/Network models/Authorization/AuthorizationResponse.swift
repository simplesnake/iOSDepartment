//
//  AuthorizationResponse.swift
//  iOSDepartment
//
//  Created by Александр Строев on 16.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

struct AuthorizationResponse: Decodable {
    let accountId: Int64?
    let token: String?
}
