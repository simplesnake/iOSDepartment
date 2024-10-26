//
//  UIImage+Extensions.swift
//  iOSDepartment
//
//  Created by Мявкo on 26.10.24.
//  Copyright © 2024 Stroev. All rights reserved.
//

import UIKit

extension UIImage {
    
    static func systemIcon(named name: String, tintColor: UIColor = .systemOrange) -> UIImage? {
        return UIImage(systemName: name)?.withTintColor(tintColor, renderingMode: .alwaysOriginal)
    }
    
    func resizeImage(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let resizedImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        return resizedImage
    }
}
