//
//  AuthorizationViewOutput.swift
//  iOSDepartment
//
//  Created by Александр Строев on 07.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

protocol AuthorizationViewOutput: BaseViewOutput {
    var x: Int { get }
}

extension AuthorizationViewController: AuthorizationViewOutput {
    var x: Int {
        return 0
    }
    
}
