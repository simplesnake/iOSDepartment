//
//  ImageScreenInteractor.swift
//  Mobilization
//
//  Created by Ekaterina on 18/08/2021.
//  Copyright © 2021 Custom company name. All rights reserved.
//

class ImageScreenInteractor: BaseInteractor<ImageScreenData> {
    
    weak var presenter: ImageScreenInteractorOutput!
    var network: ImageScreenNetwork!
    //var storageManager: StorageManager! опционально
}
