//
//  PaginationManager.swift
//  iOSDepartment
//
//  Created by Александр Строев on 29.08.2021.
//  Copyright © 2021 Stroev. All rights reserved.
//

import UIKit

class TestPaginationManager: PaginationManager<PagReq, PagResp, String> {
    init(collectionView: CollectionWithPagination<String>) {
        let testMethod: TestMethod2 = TestMethod2(TestMethod2.Model(requestData: PagReq()))
        super.init(method: testMethod, collectionView: collectionView, nextPageOnWillDisplay: true, nextPageOffsetPosition: 20)
    }
}

//TODO: Нужно иметь возможность преобразовывать массив "Data" в модель для таблицы
class PaginationManager<Request: PaginationRequest, Response: PaginationResponse<Data>, Data: Decodable> {
    
    private var collectionView: CollectionWithPagination<Data> {
        didSet {
//            collectionView.numberOfItemsInSection = {
//                [weak self] _, _ in
//                guard let self = self else { return 0 }
//                return self.data.count
//            }
            
            if nextPageOnWillDisplay {
                collectionView.willDisplay.append(willDisplayLogic)
            }
        }
    }
    
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
    private var nextPageOnWillDisplay: Bool
    private lazy var willDisplayLogic: (UICollectionView, UICollectionViewCell, IndexPath) -> () = {
        if $2.row >= self.collectionView.data.count - self.nextPageOffsetPosition {
            self.nextPage()
        }
    }
    
    private var method: BaseTarget<Request, Response> {
        didSet {
            method.model.onRequestComplete = {
                [weak self] in
                guard let self = self else { return }
                
                self.inProcess = false
                if self.offset == 0 {
                    self.collectionView.refreshControl?.endRefreshing()
                }
            }
            method.model.onSuccess = {
                [weak self] response in
                guard let self = self else { return }
                
                if self.needRefresh {
                    self.collectionView.data = response.data
                } else {
                    self.collectionView.data.append(contentsOf: response.data)
                }
                
                self.total = response.total
                self.offset = self.collectionView.data.count
                
                self.collectionView.reloadData()
            }
        }
    }
    private var request: Request {
        get { return method.model.requestData }
        set { method.model.requestData = newValue }
    }
    
    init(method: BaseTarget<Request, Response>, collectionView: CollectionWithPagination<Data>, nextPageOnWillDisplay: Bool = true, nextPageOffsetPosition: Int = 1) {
        
        self.method = method
        
        self.nextPageOnWillDisplay = nextPageOnWillDisplay
        self.nextPageOffsetPosition = nextPageOffsetPosition
        
        self.collectionView = collectionView
    }
    
    func firstPage() {
        offset = 0
        nextPage(needRefresh: true)
    }
    
    func nextPage(needRefresh: Bool = false) {
        if inProcess { return }
        
        if let total = total, offset >= total {
            collectionView.refreshControl?.endRefreshing()
            return
        }
        
        self.needRefresh = needRefresh
        inProcess = true
        method.request()
    }
}

class TestMethod: BaseTarget<PagReq, PaginationResponse<String>> {
    class Model: RequestModel<PagReq, PaginationResponse<String>> {}

    init(_ model: Model) {
        super.init(model: model, method: .get)
        self.path = "/info/experience"
    }
}

class TestMethod2: BaseTarget<PagReq, PagResp> {
    class Model: RequestModel<PagReq, PagResp> {}

    init(_ model: Model) {
        super.init(model: model, method: .get)
        self.path = "/info/experience"
    }
}

class PagResp: PaginationResponse<String> {
//    var r: Int
//
//    init() {
//        self.r = 1
//        super.init(limit: 10, offset: 0)
//    }
}

class PagReq: PaginationRequest {
    var q: Int
    
    init() {
        self.q = 1
        super.init(limit: 10, offset: 0)
    }
}
