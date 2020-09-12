//
//  RequestBuilder.swift
//  iOSDepartment
//
//  Created by Александр Строев on 12.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

import Moya
import Foundation

public class RequestBuilder<T1: Encodable, T2: Decodable>{
    
    init(){}
    
    var unknownError: ErrorResponse = ErrorResponse(message: "Unknown error", details: "Update API or contact the backend developer")
    
    func request(
        requestData: BaseTarget<T1>,
        header: [String:String] = ["Authorization": "ТУТ ТОКЕН)"],//["Accept" : "application/json"],
        onSuccess: ((T2) -> ())? = nil,//Данные успешно получены и распарсены
        onError: ((Int, ErrorResponse) -> ())? = nil,//Код и ошибка с сервера
        onFail: ((Error) -> ())? = nil,//Ошибка запроса на клиенте
        onParseDataError: (()->())? = nil,//Данные успешно получены, но распарсить не удалось
        onRequestComplete: (()->())? = nil,//Завершение выполнения запроса независимо от результата. Выполняется всегда и перед всеми остальными событиями
        view: BaseViewInput? = nil,
        showLoader: Bool = true,
        showToast: Bool = true) {
        
        let provider = MoyaProvider<BaseTarget<T1>>()
        
        
        if showLoader {
            view?.loader(true)
        }
        
        let view = view
        provider.request(requestData) { [weak self] result in
            if showLoader {
                view?.loader(false)
            }
            onRequestComplete?()
            switch result {
            case .success(let response):
                if(response.statusCode == 200){
                    let responseData = try? response.map(T2.self)
                    guard let data = responseData else {
                        if showToast {
                            view?.showToast("Ошибка парсинга")
                        }
                        onParseDataError?()
                        return
                    }
                    
                    onSuccess?(data)
                    return
                }
                
                print("Ошибка: \(response.statusCode)")
                guard let errorData = try? response.map(ErrorResponse.self) else {
                    print("Описание ошибки: неизвестная ошибка")
                    if showToast {
                        view?.showToast("Ошибка: \(response.statusCode)")
                    }
                    onError?(-1, self!.unknownError)
                    return
                }
                
                print("Описание ошибки: \(ErrorsDescription.getLocalizableDescription(id: errorData.details))")
                if showToast {
                    view?.showToast("Ошибка: \(response.statusCode)\nОписание ошибки: \(ErrorsDescription.getLocalizableDescription(id: errorData.details))")
                }
                
//                if response.statusCode == 400 {
//                    Storer.token = nil
//                }
                
                onError?(response.statusCode, errorData)
                
            case .failure(let error):
                print(error.errorDescription ?? "Unknown error")
                if showToast {
                    view?.showToast("Ошибка запроса на клиенте: \(error.errorDescription ?? "неизвестная ошибка")")
                }
                onFail?(error)
            }
        }
    }
    
}

class ErrorResponse : Decodable
{
    var message : String?
    var details : String?
    
    init(message : String?, details : String?) {
        self.message = message
        self.details = details
    }
}

class ErrorsDescription {
    
    private static let errors: [String] =
        ["BAD_TOKEN. not authorized"
        ]
    
    
    public static func getLocalizableDescription(id: String?) -> String {
        guard let id = id, id != "", errors.contains(id) else {
//            return NSLocalizedString("error.something_wrong", comment: "")
            return "Неизвестная ошибка сервера"
        }
        return NSLocalizedString(id, comment: "")
    }
}

extension RequestBuilder {
    func testRequest(x: Int) {
        request(requestData: <#T##TargetType#>)
    }
    
}
