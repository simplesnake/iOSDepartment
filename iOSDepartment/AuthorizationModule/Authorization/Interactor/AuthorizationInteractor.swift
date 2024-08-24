//
//  AuthorizationInteractor.swift
//  iOSDepartment
//
//  Created by Fox on 24.08.2024.
//  Copyright © 2024 Stroev. All rights reserved.
//

import Foundation

class AuthorizationInteractor: BaseInteractor<AuthorizationData> {
    
    weak var presenter: AuthorizationInteractorOutput!
    var network: AuthorizationNetwork!
    var storageManager: StorageManager!
}
