//
//  PaginationManager.swift
//  iOSDepartment
//
//  Created by Александр Строев on 29.08.2021.
//  Copyright © 2021 Stroev. All rights reserved.
//

import UIKit

protocol PaginationManagerDelegate {
    func refresh()
}

class PaginationManager<Request: PaginationRequest, Response: PaginationResponse<Data>, Data: Decodable> {
    
    private var collectionViewDelegate: CollectionWithPaginationDelegate
    
    private var limit: Int {
        get { return request.limit }
        set { request.limit = newValue }
    }
    private var offset: Int {
        get { return request.offset }
        set { request.offset = newValue }
    }
    private var total: Int?
    
    private var inProcess: Bool = false
    private var needRefresh: Bool = false
    private var nextPageOffsetPosition: Int
    private lazy var willDisplayLogic: (UICollectionView, UICollectionViewCell, IndexPath) -> () = {
        if $2.row >= self.collectionViewDelegate.getData().count - self.nextPageOffsetPosition {
            self.nextPage()
        }
    }
    
    private var method: BaseTarget<Request, Response>
    var request: Request {
        get { return method.model.requestData }
        set { method.model.requestData = newValue }
    }
    
    init(method: BaseTarget<Request, Response>, collectionView: CollectionWithPagination<Data>, nextPageOnWillDisplay: Bool = true, nextPageOffsetPosition: Int = 1) {
        
        self.method = method
        self.nextPageOffsetPosition = nextPageOffsetPosition
        collectionViewDelegate = collectionView
        
        initMethod()
        
        collectionView.setPaginationManagerDelegate(delegate: self)
        if nextPageOnWillDisplay {
            collectionView.setWillDisplayLogic(willDisplayLogic)
        }
        collectionView.setup()
    }
    
    private func initMethod() {
        method.model.onRequestComplete = {
            [weak self] in
            guard let self = self else { return }
            
            self.inProcess = false
            if self.offset == 0 {
                self.collectionViewDelegate.endRefreshing()
            }
        }
        method.model.onSuccess = {
            [weak self] response in
            guard let self = self else { return }
            
            if self.needRefresh {
                self.collectionViewDelegate.setData(response.data)
            } else {
                self.collectionViewDelegate.appendData(response.data)
            }
            
            self.total = response.total
            self.offset = self.collectionViewDelegate.getData().count
            
            self.collectionViewDelegate.reloadData()
        }
    }
    
    func firstPage() {
        offset = 0
        nextPage(needRefresh: true)
    }
    
    func nextPage(needRefresh: Bool = false) {
        if inProcess { return }
        
        if let total = total, offset >= total {
            collectionViewDelegate.endRefreshing()
            return
        }
        
        self.needRefresh = needRefresh
        inProcess = true
        method.request()
    }
}

extension PaginationManager: PaginationManagerDelegate {
    func refresh() {
        firstPage()
    }
}
