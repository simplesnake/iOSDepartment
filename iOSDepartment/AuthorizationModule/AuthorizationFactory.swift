//
//  AuthorizationFactory.swift
//  iOSDepartment
//
//  Created by Fox on 23.08.2024.
//  Copyright © 2024 Stroev. All rights reserved.
//

import Foundation

class AuthorizationFactory {
    
    enum AuthorizationType {
        case phone, email
    }
    
    struct AuthorizationConfig{
        var type: AuthorizationType = .phone
        var data: AuthorizationData? = nil
        var isShowHeader: Bool = true
        var headerText: String = ""
    }
    
    func makeAuth(config: AuthorizationConfig) -> AuthorizationViewController {
        let controller = AuthorizationAssembly.assemble(data: config.data)
        return controller
    }
    
    private func phoneConfigure(vc: AuthorizationViewController){
        
    }
    
    private func emailConfigure(vc: AuthorizationViewController){
        
    }
}
