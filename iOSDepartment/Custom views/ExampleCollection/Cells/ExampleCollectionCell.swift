//
//  ExampleCollectionCell.swift
//  iOSDepartment
//
//  Created by 7Winds - Sokol on 06.03.2022.
//  Copyright © 2022 Stroev. All rights reserved.
//

import UIKit

class ExampleCollectionCell: UICollectionViewCell {

    //MARK: - структуры и перечисления
    struct Data {
        
    }
    
    //MARK: - элементы UI
    

    //MARK: - переменные
    var data: Data! {
        didSet {
            
        }
    }
    
    //MARK: - конструкторы
    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    //MARK: - настройка UI
    func setupUI() {
        addSubviews()
        addConstraints()
    }
    
    func addSubviews() {
        addSubview()
    }
    
    func addConstraints() {
        
    }
    
    //MARK: - методы и функции
}
