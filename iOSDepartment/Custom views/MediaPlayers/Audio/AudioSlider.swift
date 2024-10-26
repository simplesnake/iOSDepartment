//
//  AudioSlider.swift
//  iOSDepartment
//
//  Created by Мявкo on 26.10.24.
//  Copyright © 2024 Stroev. All rights reserved.
//

import UIKit

final class AudioSlider: UISlider {
    
    // MARK: - override методы
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let increasedBounds = bounds.insetBy(dx: -20, dy: -20)
        return increasedBounds.contains(point)
    }
    
    
    // MARK: - конструкторы
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - настройка UI
    private func setupAppearance() {
        thumbTintColor = .systemOrange
        maximumTrackTintColor = .lightGray
        minimumTrackTintColor = .systemOrange
        minimumValue = 0
        value = 0
        
        let thumbImage = UIImage.systemIcon(named: "circle.fill")?
            .resizeImage(size: CGSize(width: 15, height: 15))
        setThumbImage(thumbImage, for: .normal)
        setThumbImage(thumbImage, for: .highlighted)
        setThumbImage(thumbImage, for: .focused)
    }
}

