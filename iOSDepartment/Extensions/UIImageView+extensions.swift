//
//  UIImageView+extensions.swift
//  iOSDepartment
//
//  Created by 7winds on 06.03.2022.
//  Copyright © 2022 Stroev. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {

    func downloadImage(from url: URL, aspectMode: UIView.ContentMode? = .scaleAspectFill, placeholder: String? = nil, completion: (() -> ())! = {}) {
        
        let modifier = AnyModifier { request in
            var r = request
            r.setValue("Bearer \(StorageManager.shared.token)", forHTTPHeaderField: "Authorization")
            
            return r
        }
        if aspectMode != nil {
            self.contentMode = aspectMode!
        }
        kf.indicatorType = .activity
        kf.setImage(
            with: url,
            placeholder: UIImage(named: ""),
            options: [
                .transition(.fade(0.0)),
                .cacheOriginalImage,
                .requestModifier(modifier)
            ], completionHandler:
                {
                    result in
                    switch result {
                    case .success(_):
                        
                        completion?()
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                    }
                })
        
    }
    
    
}
