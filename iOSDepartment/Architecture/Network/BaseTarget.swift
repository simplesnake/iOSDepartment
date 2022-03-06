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
    let baseURL: URL = URL(string: "https://backend.mobilization2021.tk/")!
    
//    let baseURL: URL = URL(string: "https://backend.beta.mobilization2021.tk/")!
    //Надо сделать получение параметров из plist.info
//    let baseURL: URL = PlistManager<BaseURL>().value.url
    var method: Moya.Method = .get
    let sampleData: Data = Data()
    var headers: [String : String]? {
        return ["Authorization": token]
    }
    var task: Task {
        return task(data: model.requestData)
    }
    
    let model: RequestModel<T1, T2>
    
    var unknownError: ErrorResponse = ErrorResponse(message: "Здесь неопределенная ошибка", details: "")
    
    var token: String {
        return "Bearer \(StorageManager.shared.token)"
    }
    
    var multipart: [MultipartFormData]?
    
    var ignoreParameters: Bool = false
    
    init(model: RequestModel<T1, T2>, method: Moya.Method = .get, multipart: [MultipartFormData]? = nil) {
        self.model = model
        self.method = method
        
        
        self.multipart = multipart
    }
    
    func request() {
        print("Начало запроса")
        let provider = MoyaProvider<Self>(plugins: [NetworkLoggerPlugin(verbose: true)])
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
                    print()
                    self.model.onSuccess?(data)
                    return
                }
                
                print("Ошибка: \(response.statusCode)")
                guard let errorData = try? response.map(ErrorResponse.self) else {
//                                throw MoyaError.stringMapping(self)
                            
//                guard let errorData = try? response.map(ErrorResponse.self) else {
                    print("Описание ошибки: неизвестная ошибка")
                    if self.model.showToast {
                        self.model.view?.showToast("Ошибка: \(response.statusCode)")
                    }
                    self.model.onError?(-1, self.unknownError)
                    return
                }
                
                if self.model.showToast {
                    self.model.view?.showToast("\(errorData.message.localizeError)")
                }
                
//                Обычно это ошибка протухшего токена
                if response.statusCode == 401 {
                    self.model.view?.loader(false)
//                    self.model.view?.showToast("401")
                    print("!!Ошибка 401")
                    print("!!Токен запроса \(self.token)")
                    print("!!Токен в см \(StorageManager.shared.token)")
                    print("!!Тефреш токен в см \(StorageManager.shared.refreshToken)")
                    self.refreshToken(view: self.model.view)
                    return
                }
                
                
                
                self.model.onError?(response.statusCode, errorData)
                
            case .failure(let error):
                print(error.errorDescription ?? "Unknown error")
                if self.model.showToast {
                    if error.errorDescription == "Вероятно, соединение с интернетом прервано."{
                        self.model.view?.loader(false)
                        self.model.view?.showToast("Интернет недоступен")
                    } else {
                        self.model.view?.showToast("\(error.errorDescription ?? "неизвестная ошибка")")
                    }
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
            if let multipart = multipart {
                if ignoreParameters {
                    return .uploadCompositeMultipart(multipart, urlParameters: toParams(data: ""))
                }
                
                return .uploadCompositeMultipart(multipart, urlParameters: toParams(data: data))
            } else {
                return .requestParameters(parameters: toParams(data: data), encoding: JSONEncoding.default)
            }
        case .get:
            return .requestParameters(parameters: toParams(data: data), encoding: URLEncoding.default)
        case .delete:
            return .requestCompositeData(bodyData: Data(), urlParameters: toParams(data: data))
        case .patch:
            return .requestParameters(parameters: toParams(data: data), encoding: JSONEncoding.default)
        default:
            return .requestParameters(parameters: toParams(data: data), encoding: JSONEncoding.default)
        }
        
    }
    
//    func refreshToken(_ model: API.RefreshToken.Model) {
//
//    }
    
    private func toParams<T: Encodable>(data : T) -> [String: Any] {
            var params = (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(data))) as? [String: Any] ?? [:]
            //Для отправки null серверу
            params.forEach({
                (key,value) in
                if let stringValue = value as? String, stringValue == "null" {
                    params[key] = NSNull()
                }
                if let intValue = value as? Int32, intValue == Int32.min {
                    params[key] = NSNull().encode(with: NSCoder())
                }
            })

            return params
        }
    //  Запрос на получение нового токена
    private func refreshToken(view: (LoaderProtocol & ToastProtocol)?) {
        
//        let model = API.RefreshToken<T1, T2>.Model<T1, T2>(requestData: AuthorizationRefreshRequest(token: StorageManager.sharedInstance.refreshToken),
//        onError: {
//            [weak self] _, _ in
//            print("!!В авторизацию onError")
//            self?.model.view?.showToast("В авторизацию onError")
//            RealReactive.event(.logout)
//            //в авторизацию
//        }, onFail: {
//            [weak self] _ in
//            print("!!В авторизацию onFail")
//            self?.model.view?.showToast("В авторизацию onFail")
//            RealReactive.event(.logout)
//        }, view: view, showLoader: true)
//        model.failedRequest = self
//        let onSuccess: ((AuthorizationRefreshResponse)->()) = {
//            response in
//            StorageManager.sharedInstance.refreshToken = response.refreshToken
//            StorageManager.sharedInstance.token = response.token
//            print("!!Токен обновлен")
//            model.failedRequest.request()
//        }
//        model.onSuccess = onSuccess
//        API.RefreshToken(model).request()
//
    }
}



