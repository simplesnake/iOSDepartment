//
//  CameraAndGaleryWithCrop.swift
//  WishBoxReborn
//
//  Created by 7Winds on 17.02.2022.
//

import Foundation
import UIKit

class CameraAndGaleryWithCrop {
    
    enum Result {
        case success(UIImage)
        case cancel
        case error
    }
    
    let navigationController: UINavigationController
    
    var croppingParameters: CroppingParameters {
        CroppingParameters(isEnabled: true, allowResizing: true, allowMoving: true, minimumSize: CGSize(width: 175, height: 175))
    }
    
    lazy var cameraViewController: CameraViewController = {
        let view = CameraViewController(croppingParameters: croppingParameters, allowsLibraryAccess: true, allowsSwapCameraOrientation: true, allowVolumeButtonCapture: true, completion: {
            [weak self] image, asset in
            
        })
        
        return view
    }()
    
    lazy var libraryViewController: PhotoLibraryViewController = {
        let view: PhotoLibraryViewController = PhotoLibraryViewController()
        return view
    }()
    
    var result: ((Result) -> ())?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    func openCamera(needCrop: Bool = true) {
        
        cameraViewController.onCompletion = {
            [weak self] image, asset in
            guard let self = self else { return }
            
            if needCrop {
                guard let image = asset?.image else {
                    self.result?(.error)
                    return
                }
                self.toCrop(image: image) {
                    [weak self] result in
                    guard let self = self else { return }
                    
                    switch result {
                        case .success(let image):
                            self.result?(.success(image))
                            self.removePreviousScreen()
                            self.navigationController.popViewController(animated: true)
                        case .cancel:
                            print("Отмена")
                            self.result?(.cancel)
                            self.navigationController.popViewController(animated: true)
                        case .error:
                            print("Что-то пошло не так")
                            self.result?(.error)
                            self.removePreviousScreen()
                            self.navigationController.popViewController(animated: true)
                    }
                }
            } else {
                if let image = image {
                    self.result?(.success(image))
                } else {
                    self.result?(.error)
                }
                self.navigationController.popViewController(animated: true)
            }
        }
        
        cameraViewController.onGalerySelected = {
            [weak self] in
            guard let self = self else { return }
            self.openGalery(needCrop: needCrop, fromCamera: true)
        }
        
        cameraViewController.closeButtonTap = {
            [weak self] in
            guard let self = self else { return }
            self.navigationController.popViewController(animated: true)
        }
        
        navigationController.pushViewController(cameraViewController, animated: true)
    }
    
    func openGalery(needCrop: Bool = true, fromCamera: Bool = false) {
        
        libraryViewController.onSelectionComplete = {
            [weak self] asset in
            guard let self = self else { return }
            guard let asset = asset else {
                print("Чё-то пошло не так")
                self.navigationController.popViewController(animated: true)
                return
            }
            
            guard let image = asset.image else {
                print("asset косячный")
                return
            }
            
            if needCrop {
                self.toCrop(image: image) {
                    [weak self] result in
                    guard let self = self else { return }
                    
                    switch result {
                        case .success(let image):
                            self.result?(.success(image))
                            self.removePreviousScreen()
                            if fromCamera { self.removePreviousScreen() }
                            self.navigationController.popViewController(animated: true)
                        case .cancel:
                            print("Отмена")
                            self.result?(.cancel)
                            self.navigationController.popViewController(animated: true)
                        case .error:
                            print("Что-то пошло не так")
                            self.result?(.error)
                            self.removePreviousScreen()
                            if fromCamera { self.removePreviousScreen() }
                            self.navigationController.popViewController(animated: true)
                    }
                }
            } else {
                self.result?(.success(image))
                self.navigationController.popViewController(animated: true)
            }
            
        }
        
        navigationController.pushViewController(libraryViewController, animated: true)
    }
    
    func toCrop(image: UIImage, result: ((Result) -> ())? = nil) {
        let cropController = ConfirmViewController(image: image, croppingParameters: self.croppingParameters)
        cropController.onComplete = { image, asset in
            if let image = image {
                result?(.success(image))
            } else {
                result?(.error)
            }
        }
        cropController.onCancel = {
            result?(.cancel)
        }
        navigationController.pushViewController(cropController, animated: true)
    }
    
    func removePreviousScreen() {
        let viewControllersCount = navigationController.viewControllers.count
        navigationController.viewControllers.remove(at: viewControllersCount - 2)
    }
    
}
