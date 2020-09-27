//
//  ExampleLoader.swift
//  iOSDepartment
//
//  Created by Александр Строев on 27.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

import UIKit

class ExampleLoader: BaseLoader, LoaderViewProtocol {
    
    lazy var view: UIView! = {
        let view = UILabel()
        view.text = "FirstLoader"
        view.textColor = .yellow
        return view
    }()
    
    func startAnimation() {
        view.rotate360(roundDuration: 0.5, times: 3)
    }
    
    func removeLoader() {
        view.removeFromSuperview()
    }
    
    func showLoader(_ parent: UIView) {
        hideLoader(parent)
        parent.addSubview(view)
        view.snp.makeConstraints({
            make in
            make.center.equalToSuperview()
        })
        startAnimation()
    }
    
    func hideLoader(_ parent: UIView) {
        view.stopRotating()
        removeLoader()
    }
    
}
