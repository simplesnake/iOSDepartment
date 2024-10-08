//
//  AuthorizationInteractor.swift
//  iOSDepartment
//
//  Created by Александр Строев on 07.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

class AuthorizationInteractor: BaseInteractor<AuthorizationData> {
    weak var presenter: AuthorizationInteractorOutput!
    var network: AuthorizationNetwork!
    var storageManager: StorageManager!
}
