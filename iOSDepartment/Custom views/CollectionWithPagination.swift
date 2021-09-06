//
//  CollectionWithPagination.swift
//  iOSDepartment
//
//  Created by 7Winds - Sokol on 06.09.2021.
//  Copyright © 2021 Stroev. All rights reserved.
//

import UIKit

class CollectionWithPagination<PaginationData: Decodable>: BaseCollectionView {
    
    var data: [PaginationData] = [] {
        didSet {
            reloadData()
        }
    }
    
    var cellForItemAtWithData: ((UICollectionView, IndexPath, PaginationData) -> UICollectionViewCell)?
    
    func setup() {
        numberOfItemsInSection = {
            [weak self] _, _ in
            guard let self = self else { return 0 }
            return self.data.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cellForItemAtWithData?(collectionView, indexPath, data[indexPath.row]) ?? UICollectionViewCell()
    }
    
}
