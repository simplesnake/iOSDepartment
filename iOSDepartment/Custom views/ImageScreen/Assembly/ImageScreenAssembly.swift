//
//  ImageScreenAssembly.swift
//  Mobilization
//
//  Created by Ekaterina on 18/08/2021.
//  Copyright © 2021 Custom company name. All rights reserved.
//

class ImageScreenAssembly: BaseAssembly {
    
    static func assemble(data: ImageScreenData? = nil) -> ImageScreenViewController {
        let view = ImageScreenViewController()
        let router = ImageScreenRouter(view)
        let presenter = ImageScreenPresenter()
        let interactor = ImageScreenInteractor()
        let localization = ImageScreenLocalization()
        let network = ImageScreenNetwork()

        view.presenter = presenter
        view.localization = localization
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        presenter.screenUtilities = view
        interactor.presenter = presenter
        interactor.data = data
        interactor.network = network
        //interactor.storageManager = StorageManager.shared опционально
        
        return view
    }
    
}
