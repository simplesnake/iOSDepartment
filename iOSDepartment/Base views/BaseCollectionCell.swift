//
//  BaseCollectionCell.swift
//  WishBoxReborn
//
//  Created by 7Winds - Sokol on 01.02.2022.
//

import UIKit

class BaseCollectionCell: UICollectionViewCell {
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
