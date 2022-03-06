//
//  ImageScreenInteractorInput.swift
//  Mobilization
//
//  Created by Ekaterina on 18/08/2021.
//  Copyright © 2021 Custom company name. All rights reserved.
//

import UIKit

protocol ImageScreenInteractorInput: BaseInteractorInput {
    var mediaData: String? { get }
    var image: UIImage? { get }
}

extension ImageScreenInteractor: ImageScreenInteractorInput {
    
    var mediaData: String? {
        return data.mediaData
    }
    var image: UIImage? {
        return data.image
    }
    
}
