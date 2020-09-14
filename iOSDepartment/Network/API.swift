//
//  API.swift
//  iOSDepartment
//
//  Created by Строев Александр on 11.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

import Foundation
import Moya

class API: NSObject {
    
    static var provider: Any?
    
    public static let server: String = "http://185.188.183.104"
    public static let serverPort: String = "8090"
    public static let baseURL: URL = URL(string: "\(server):\(serverPort)/app/api/")!
    
    class Authorization: BaseTarget<AuthorizationRequest, AuthorizationResponse> {
        class Model: RequestModel<AuthorizationRequest, AuthorizationResponse> {}
        
        init(_ model: Model) {
            super.init(model: model)
            self.path = "/user/choose/"
        }
        
        override var headers: [String : String]? {
            return [:]
        }
        
    }
}

struct AuthorizationRequest: Encodable {
    let login: String
    let password: String
}

struct AuthorizationResponse: Decodable {
    let accountId: Int64?
    let token: String?
}

class BaseTarget<T1: Encodable, T2: Decodable>: TargetType {
    
    var path: String = ""
    
    let baseURL: URL = URL(string: "http://185.188.183.104:8090/app/api/")!
//    var baseURL = URL(string: "https://dev.choose2020.tk/api")!
    var method: Moya.Method = .get
    var sampleData: Data = Data()
    var headers: [String : String]? {
        return ["Authorization": "Тут токен напрямую из хранилища"]
    }
    var task: Task {
        return task(data: model.requestData)
    }
    
    var model: RequestModel<T1, T2>
    
    var unknownError: ErrorResponse = ErrorResponse(message: "Unknown error", details: "Update API or contact the backend developer")
    
    init(model: RequestModel<T1, T2>, method: Moya.Method = .get) {
        self.model = model
        self.method = method
    }
    
    func request(model: RequestModel<T1, T2>) {
            
//        let provider = MoyaProvider<BaseTarget<T1, T2>>()
        let provider = MoyaProvider<Self>()
        API.provider = provider
        
        if model.showLoader {
            model.view?.loader(true)
        }
            
        provider.request(self as! Self) { [weak self] result in
            if model.showLoader {
                model.view?.loader(false)
            }
            model.onRequestComplete?()
            switch result {
            case .success(let response):
                if(response.statusCode == 200){
                    let responseData = try? response.map(T2.self)
                    guard let data = responseData else {
                        if model.showToast {
                            model.view?.showToast("Ошибка парсинга")
                        }
                        model.onParseDataError?()
                        return
                    }
                    
                    model.onSuccess?(data)
                    return
                }
                
                print("Ошибка: \(response.statusCode)")
                guard let errorData = try? response.map(ErrorResponse.self) else {
                    print("Описание ошибки: неизвестная ошибка")
                    if model.showToast {
                        model.view?.showToast("Ошибка: \(response.statusCode)")
                    }
                    model.onError?(-1, self!.unknownError)
                    return
                }
                
                print("Описание ошибки: \(ErrorsDescription.getLocalizableDescription(id: errorData.details))")
                if model.showToast {
                    model.view?.showToast("Ошибка: \(response.statusCode)\nОписание ошибки: \(ErrorsDescription.getLocalizableDescription(id: errorData.details))")
                }
                
    //            Обычно это ошибка протухшего токена
    //            if response.statusCode == 400 {
    //                Storer.token = nil
    //            }
                
                model.onError?(response.statusCode, errorData)
                
            case .failure(let error):
                print(error.errorDescription ?? "Unknown error")
                if model.showToast {
                    model.view?.showToast("Ошибка запроса на клиенте: \(error.errorDescription ?? "неизвестная ошибка")")
                }
                model.onFail?(error)
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

class RequestModel<T1: Encodable, T2: Decodable> {
    var requestData: T1
    var onSuccess: ((T2) -> ())? = nil//Данные успешно получены и распарсены
    var onError: ((Int, ErrorResponse) -> ())? = nil//Код и ошибка с сервера
    var onFail: ((Error) -> ())? = nil//Ошибка запроса на клиенте
    var onParseDataError: (()->())? = nil//Данные успешно получены, но распарсить не удалось
    var onRequestComplete: (()->())? = nil//Завершение выполнения запроса независимо от результата. Выполняется всегда и перед всеми остальными событиями
    var view: BaseViewInput? = nil
    var showLoader: Bool = true
    var showToast: Bool = true
    
    init(requestData: T1, onSuccess: ((T2) -> ())? = nil, onError: ((Int, ErrorResponse) -> ())? = nil, onFail: ((Error) -> ())? = nil, onParseDataError: (()->())? = nil, onRequestComplete: (()->())? = nil, view: BaseViewInput? = nil, showLoader: Bool = true, showToast: Bool = true) {
        self.requestData = requestData
        self.onSuccess = onSuccess
        self.onError = onError
        self.onFail = onFail
        self.onParseDataError = onParseDataError
        self.onRequestComplete = onRequestComplete
        self.view = view
        self.showLoader = showLoader
        self.showToast = showToast
    }
}

class EmptyRequest: Encodable {}

protocol MultipartRequest {
    var multipartData: [MultipartFormData] { get }
}
