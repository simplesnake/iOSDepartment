//
//  BaseCollectionView.swift
//  iOSDepartment
//
//  Created by Александр Строев on 29.08.2021.
//  Copyright © 2021 Stroev. All rights reserved.
//

import UIKit

class BaseCollectionView: UICollectionView {
    
    var isAutoDimensionHeight: Bool = false
    
    var sizeForItemAt: ((UICollectionView, UICollectionViewLayout, IndexPath) -> CGSize)?
    var numberOfItemsInSection: ((UICollectionView, Int) -> Int)?
    var cellForItemAt: ((UICollectionView, IndexPath) -> UICollectionViewCell)?
    var willDisplay: [(UICollectionView, UICollectionViewCell, IndexPath) -> ()] = []
    var didSelectItemAt: ((BaseCollectionView, IndexPath) -> ())?
    var insetForSection: ((UICollectionView, UICollectionViewLayout, Int)  -> UIEdgeInsets)?
    
    override var contentSize: CGSize {
        didSet {
            guard isAutoDimensionHeight else { return }
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        guard isAutoDimensionHeight else { return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric) }
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
    
    init(frame: CGRect, collectionViewLayout: UICollectionViewLayout, cellsForRegistration: [BaseCollectionCell.Type] = []) {
        super.init(frame: frame, collectionViewLayout: collectionViewLayout)
        delegate = self
        dataSource = self
        
        cellsForRegistration.forEach({ register($0) })
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func registerNib(_ cellType: BaseCollectionCell.Type) {
        register(UINib(nibName: cellType.className, bundle: nil), forCellWithReuseIdentifier: cellType.className)
    }

    func register<Cell: BaseCollectionCell>(_ type: Cell.Type) {
        register(type, forCellWithReuseIdentifier: type.className)
    }

    func register<HeaderFooter: UITableViewHeaderFooterView>(headerFooter type: HeaderFooter.Type) {
        register(type, forCellWithReuseIdentifier: type.className)
    }

    func registerNib<HeaderFooter: UITableViewHeaderFooterView>(headerFooter type: HeaderFooter.Type) {
        register(UINib(nibName: type.className, bundle: nil), forCellWithReuseIdentifier: type.className)
    }

    func dequeue<Cell: BaseCollectionCell>(_ cell: Cell.Type, for indexPath: IndexPath) -> Cell {
        return dequeueReusableCell(withReuseIdentifier: Cell.className, for: indexPath) as! Cell
    }

    func dequeue<Cell: BaseCollectionCell>(_ cell: Cell.Type, for row: Int, in section: Int = 0) -> Cell {
        return dequeue(cell, for: IndexPath(row: row, section: section))
    }
    
}

extension BaseCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForItemAt?(collectionView, collectionViewLayout, indexPath) ??  CGSize(width: collectionView.frame.width, height: collectionView.frame.height / 5)//Значение по умолчанию, параметры ширины и высоты не несут смысловой нагрузки
        
        //UICollectionViewFlowLayout.automaticSize
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        willDisplay.forEach({
            closure in
            closure(collectionView, cell, indexPath)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItemAt?(self, indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insetForSection?(collectionView, collectionViewLayout, section) ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension BaseCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Количество секций всегда должно быть == 1
        return numberOfItemsInSection?(collectionView, section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cellForItemAt?(collectionView, indexPath) ?? BaseCollectionCell()
    }
}
