//
//  ExampleCollection.swift
//  iOSDepartment
//
//  Created by 7Winds - Sokol on 06.03.2022.
//  Copyright © 2022 Stroev. All rights reserved.
//

import UIKit

class ExampleCollection: BaseCollectionView {
    
    var data: [ExampleCollectionCell.Data] = [] {
        didSet {
            reloadData()
        }
    }
    
    init(frame: CGRect = CGRect.zero, collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: collectionViewLayout)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        register(ExampleCollectionCell.self)
        
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        cellForItemAt = {
            [weak self] tableView, indexPath in
            guard let self = self else { return UICollectionViewCell() }
            
            let cell: ExampleCollectionCell = tableView.dequeue(for: indexPath)
            
            cell.data = self.data[indexPath.row]
            
            return cell
        }
        
        sizeForItemAt = {
            [weak self] tableView, layout, indexPath in
            guard let self = self else { return CGSize.zero }
            
            return CGSize(width: ширина, height: высота)
        }
        
        numberOfItemsInSection = {
            [weak self] tableView, _ in
            guard let self = self else { return 0 }
            return self.data.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

