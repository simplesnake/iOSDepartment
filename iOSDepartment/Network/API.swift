//
//  API.swift
//  iOSDepartment
//
//  Created by Строев Александр on 11.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

import Foundation
//import Moya

class API: NSObject {
    class TestAPI: BaseTarget<EmptyRequest, TestApiResponse> {
        init(requestData: RequestModel<EmptyRequest> = nil) {
            super.init(requestData: requestData)
            self.path = "/user/choose/"
        }
        
        override var headers: [String : String]? {
            return [:]
        }
    }
}



struct TestApiResponse: Decodable {
    
}




//class BaseChooseProvider<T: Encodable, T2: Decodable>: BaseTarget<T> {
//}

class BaseTarget<T1: Encodable, T2: Decodable>: TargetType {
    
    var path: String = ""
    
    var baseURL = URL(string: "https://dev.choose2020.tk/api")!
    var method: Moya.Method = .get
    var sampleData: Data = Data()
    var headers: [String : String]? {
        return ["Authorization": "Тут токен напрямую из хранилища"]
    }
    var task: Task {
        return task(data: requestModel?.requestData)
    }
    
    var requestModel: RequestModel<T1>?
    
    var unknownError: ErrorResponse = ErrorResponse(message: "Unknown error", details: "Update API or contact the backend developer")
    
    init(requestModel: RequestModel<T1>?, method: Moya.Method = .get) {
        self.requestModel = requestModel
        self.method = method
    }
    
    func task<T: Encodable>(data: T?) -> Task {
        
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
    
    func toParams<T: Encodable>(data : T) -> [String: Any]
    {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(data))) as? [String: Any] ?? [:]
    }
    
    func request(model: RequestModel<T1>) {
            
        let provider = MoyaProvider<BaseTarget<T1, T2>>()
        
        if showLoader {
            view?.loader(true)
        }
            
        let view = model.view
            provider.request(self) { [weak self] result in
                if requestModel?.showLoader {
                    view?.loader(false)
                }
                requestModel?.onRequestComplete?()
                switch result {
                case .success(let response):
                    if(response.statusCode == 200){
                        let responseData = try? response.map(T2.self)
                        guard let data = responseData else {
                            if requestModel?.showToast {
                                requestModel?.view?.showToast("Ошибка парсинга")
                            }
                            requestModel?.onParseDataError?()
                            return
                        }
                        
                        requestModel?.onSuccess?(data)
                        return
                    }
                    
                    print("Ошибка: \(response.statusCode)")
                    guard let errorData = try? response.map(ErrorResponse.self) else {
                        print("Описание ошибки: неизвестная ошибка")
                        if showToast {
                            requestModel?.view?.showToast("Ошибка: \(response.statusCode)")
                        }
                        onError?(-1, self!.unknownError)
                        return
                    }
                    
                    print("Описание ошибки: \(ErrorsDescription.getLocalizableDescription(id: errorData.details))")
                    if requestModel?.showToast {
                        requestModel?.view?.showToast("Ошибка: \(response.statusCode)\nОписание ошибки: \(ErrorsDescription.getLocalizableDescription(id: errorData.details))")
                    }
                    
    //                if response.statusCode == 400 {
    //                    Storer.token = nil
    //                }
                    
                    requestModel?.onError?(response.statusCode, errorData)
                    
                case .failure(let error):
                    print(error.errorDescription ?? "Unknown error")
                    if requestModel?.showToast {
                        requestModel?.view?.showToast("Ошибка запроса на клиенте: \(error.errorDescription ?? "неизвестная ошибка")")
                    }
                    requestModel?.onFail?(error)
                }
            }
        }
}

struct RequestModel<T1: Encodable, T2: Decodable> {
    var requestData: T1
    var onSuccess: ((T2) -> ())? = nil//Данные успешно получены и распарсены
    var onError: ((Int, ErrorResponse) -> ())? = nil//Код и ошибка с сервера
    var onFail: ((Error) -> ())? = nil//Ошибка запроса на клиенте
    var onParseDataError: (()->())? = nil//Данные успешно получены, но распарсить не удалось
    var onRequestComplete: (()->())? = nil//Завершение выполнения запроса независимо от результата. Выполняется всегда и перед всеми остальными событиями
    var view: BaseViewInput? = nil
    var showLoader: Bool = true
    var showToast: Bool = true
}

class EmptyRequest: Encodable {}

protocol MultipartRequest {
    var multipartData: [MultipartFormData] { get }
}
