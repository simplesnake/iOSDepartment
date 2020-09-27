//
//  API.swift
//  iOSDepartment
//
//  Created by Строев Александр on 11.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

import Foundation
import Moya

class API: NSObject {
    
    static var provider: Any?
    
    class Authorization: BaseTarget<AuthorizationRequest, AuthorizationResponse> {
        class Model: RequestModel<AuthorizationRequest, AuthorizationResponse> {}
        
        init(_ model: Model) {
            super.init(model: model, method: .post)
            self.path = "auth.login"
        }
    }
}











