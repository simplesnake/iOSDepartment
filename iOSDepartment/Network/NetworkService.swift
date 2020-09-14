//
//  NetworkService.swift
//  iOSDepartment
//
//  Created by Строев Александр on 11.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

import Foundation
//import Moya


// MARK: - ChooseService implementation
final class NetworkService {
    
//    func request<T1: TargetType, T2: Decodable>(_ request: BaseTarget<T1>) -> Single<T2> {
//        let provider = MoyaProvider<T1>(plugins: [VerbosePlugin(verbose: true)])
//        return provider.rx
//            .request(request, callbackQueue: DispatchQueue.main).observeOn(MainScheduler.instance)
//            .filterSuccessfulStatusAndRedirectCodes()
//            .map(T2.self)
//            .catchError { error in
//                if let moyaError = error as? MoyaError {
//                    return Single.error(moyaError)
//                } else if let chooseError = error as? ErrorResponse {
//                    return Single.error(chooseError)
//                } else {
//                    return Single.error(error)
//                }
//            }
//    }
//
//
//    func deleteRequest<T1: TargetType>(_ request: T1) -> Single<Response> {
//        let provider = MoyaProvider<T1>(plugins: [VerbosePlugin(verbose: true)])
//            return provider.rx
//                    .request(request)
//                    .filterSuccessfulStatusAndRedirectCodes()
//                    .catchError { error in
//                        if let moyaError = error as? MoyaError {
//                            return Single.error(moyaError)
//                        } else if let chooseError = error as? ErrorResponse {
//                            return Single.error(chooseError)
//                        } else {
//                            return Single.error(error)
//                        }
//                     }
//    }
    
    
    
}

// MARK: - ChooseServiceProtocol implementation
//extension NetworkService {
//    func testRequest(token: String, id: Int64) -> API.TestAPI {
//        return API.TestAPI(token: token, id: id)
//    }
//    
//}
//struct VerbosePlugin: PluginType {
//    let verbose: Bool
//
//    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
//        #if DEBUG
//        print(request.url!)
//        if let body = request.httpBody, let str = String(data: body, encoding: .utf8) {
//            if verbose {
//                print("request to send: \(str))")
//            }
//        }
//        #endif
//        return request
//    }
//
//    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
//        #if DEBUG
//        switch result {
//        case .success(let body):
//            if verbose {
//                print("Response:")
//                if let json = try? JSONSerialization.jsonObject(with: body.data, options: .mutableContainers) {
//                    print(json)
//                } else {
//                    let response = String(data: body.data, encoding: .utf8)!
//                    print(response)
//                }
//            }
//        case .failure( _):
//            break
//        }
//        #endif
//    }
//
//}
