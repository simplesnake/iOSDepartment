//
//  AuthorizationAssembly.swift
//  iOSDepartment
//
//  Created by Александр Строев on 07.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

class AuthorizationAssembly: BaseAssembly {
    
    static func assemble(data: AuthorizationData? = nil) -> AuthorizationViewController {
        let view = AuthorizationViewController()
        let router = AuthorizationRouter(view: view)
        let presenter = AuthorizationPresenter()
        let interactor = AuthorizationInteractor()
        let localization = AuthorizationLocalization()
        let network = AuthorizationNetwork()

        view.presenter = presenter
        view.localization = localization
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        interactor.data = data
        interactor.network = network
        interactor.storageManager = StorageManager.shared
        
        return view
    }
    
}
