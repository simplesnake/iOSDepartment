//
//  AuthorizationAssembly.swift
//  iOSDepartment
//
//  Created by Fox on 24.08.2024.
//  Copyright © 2024 Stroev. All rights reserved.
//

import Foundation
import UIKit

class AuthorizationAssembly: BaseAssembly {
static func assemble(data: AuthorizationData? = nil) -> AuthorizationViewController {
        let view = AuthorizationViewController()
        let router = AuthorizationRouter(view)
        let presenter = AuthorizationPresenter()
        let interactor = AuthorizationInteractor()
        let localization = AuthorizationLocalization()
        let network = AuthorizationNetwork()
        
        
        view.presenter = presenter
        view.localization = localization
        
        presenter.view = view
	    presenter.screenUtilities = view
        presenter.interactor = interactor
        presenter.router = router
	    presenter.localization = localization
        
        interactor.presenter = presenter
        interactor.data = data ?? AuthorizationData()
        interactor.network = network
        interactor.storageManager = StorageManager.shared
        
        return view
    }
}
