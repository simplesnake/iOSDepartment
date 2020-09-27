//
//  RequestModel.swift
//  iOSDepartment
//
//  Created by Александр Строев on 16.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

class RequestModel<T1: Encodable, T2: Decodable> {
    var requestData: T1
    var onSuccess: ((T2) -> ())?//Данные успешно получены и распарсены
    var onError: ((Int, ErrorResponse) -> ())?//Код и ошибка с сервера
    var onFail: ((Error) -> ())?//Ошибка запроса на клиенте
    var onParseDataError: (()->())?//Данные успешно получены, но распарсить не удалось
    var onRequestComplete: (()->())?//Завершение выполнения запроса независимо от результата. Выполняется всегда и перед всеми остальными событиями
    var view: (LoaderProtocol & ToastProtocol)?
    var showLoader: Bool
    var showToast: Bool
    
    init(requestData: T1, onSuccess: ((T2) -> ())? = nil, onError: ((Int, ErrorResponse) -> ())? = nil, onFail: ((Error) -> ())? = nil, onParseDataError: (()->())? = nil, onRequestComplete: (()->())? = nil, view: (LoaderProtocol & ToastProtocol)? = nil, showLoader: Bool = true, showToast: Bool = true) {
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

