//
//  ImageScreenViewOutput.swift
//  Mobilization
//
//  Created by Ekaterina on 18/08/2021.
//  Copyright © 2021 Custom company name. All rights reserved.
//
import UIKit
protocol ImageScreenViewOutput: BaseViewOutput {
    var mediaData: String? { get }
    var image: UIImage? { get }
    func backButtonTap()
}

extension ImageScreenPresenter: ImageScreenViewOutput {
    
    
    var mediaData: String? {
        return interactor.mediaData
    }
    var image: UIImage? {
        return interactor.image
    }
    func backButtonTap() {
        router.back()
    }
}
