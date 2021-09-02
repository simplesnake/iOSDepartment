//
//  BaseTarget.swift
//  iOSDepartment
//
//  Created by Александр Строев on 16.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

import Moya

class BaseTarget<T1: Encodable, T2: Decodable>: TargetType {
    
    var path: String = ""
    let baseURL: URL = URL(string: "http://185.188.183.104:8090/app/api/")!
    //Надо сделать получение параметров из plist.info
//    let baseURL: URL = PlistManager<BaseURL>().value.url
    let method: Moya.Method
    let sampleData: Data = Data()
    var headers: [String : String]? {
        return ["Authorization": "Тут токен напрямую из хранилища"]
    }
    var task: Task {
        return task(data: model.requestData)
    }
    
    let model: RequestModel<T1, T2>
    
    var unknownError: ErrorResponse = ErrorResponse(message: "Unknown error", details: "Update API or contact a backend developer")
    
    init(model: RequestModel<T1, T2>, method: Moya.Method = .get) {
        self.model = model
        self.method = method
    }
    
    func request() {
        
        let provider = MoyaProvider<Self>(plugins: [VerbosePlugin(verbose: true)])
        API.provider = provider
        
        if model.showLoader {
            model.view?.loader(true)
        }
            
        provider.request(self as! Self) { [weak self] result in
            guard let self = self else { return }
            if self.model.showLoader {
                self.model.view?.loader(false)
            }
            self.model.onRequestComplete?()
            switch result {
            case .success(let response):
                if(response.statusCode == 200){
                    let responseData = try? response.map(T2.self)
                    guard let data = responseData else {
                        if self.model.showToast {
                            self.model.view?.showToast("Ошибка парсинга")
                        }
                        self.model.onParseDataError?()
                        return
                    }
                    
                    self.model.onSuccess?(data)
                    return
                }
                
                print("Ошибка: \(response.statusCode)")
                guard let errorData = try? response.map(ErrorResponse.self) else {
                    print("Описание ошибки: неизвестная ошибка")
                    if self.model.showToast {
                        self.model.view?.showToast("Ошибка: \(response.statusCode)")
                    }
                    self.model.onError?(-1, self.unknownError)
                    return
                }
                
    //            Обычно это ошибка протухшего токена
    //            if response.statusCode == 400 {
    //                Storer.token = nil
    //            }
                
                self.model.onError?(response.statusCode, errorData)
                
            case .failure(let error):
                print(error.errorDescription ?? "Unknown error")
                if self.model.showToast {
                    self.model.view?.showToast("Ошибка запроса на клиенте: \(error.errorDescription ?? "неизвестная ошибка")")
                }
                self.model.onFail?(error)
            }
        }
    }
    
    private func task<T: Encodable>(data: T?) -> Task {
        
        guard let data = data else {
            return .requestPlain
        }
                
        switch method {
        case .post:
            if let multipart = data as? MultipartRequest {
                return .uploadCompositeMultipart(multipart.multipartData, urlParameters: toParams(data: data))
            } else {
                return .requestParameters(parameters: toParams(data: data), encoding: JSONEncoding.default)
            }
        case .get:
            return .requestParameters(parameters: toParams(data: data), encoding: URLEncoding.default)
        case .delete:
            return .requestParameters(parameters: toParams(data: data), encoding: JSONEncoding.default)
        case .patch:
            return .requestParameters(parameters: toParams(data: data), encoding: JSONEncoding.default)
        default:
            return .requestParameters(parameters: toParams(data: data), encoding: JSONEncoding.default)
        }
        
    }
    
    private func toParams<T: Encodable>(data : T) -> [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(data))) as? [String: Any] ?? [:]
    }
}
