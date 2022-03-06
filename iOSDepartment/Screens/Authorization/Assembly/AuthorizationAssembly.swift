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
        let router = AuthorizationRouter(view)
        let presenter = AuthorizationPresenter()
        let localization = AuthorizationLocalization()
        let network = AuthorizationNetwork()
        let interactor = AuthorizationInteractor()

        view.presenter = presenter
        view.localization = localization
        
        router.navigation = view
        
        presenter.view = view
        presenter.screenUtilities = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        interactor.data = data
        interactor.network = network
        interactor.storageManager = StorageManager.shared
        
        return view
    }
    
}
