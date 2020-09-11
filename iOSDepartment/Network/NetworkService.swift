//
//  NetworkService.swift
//  iOSDepartment
//
//  Created by Строев Александр on 11.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

import Foundation
import Moya


// MARK: - ChooseService implementation
final class NetworkService {
    
    func request<T1: TargetType, T2: Decodable>(_ request: T1) -> Single<T2> {
        let provider = MoyaProvider<T1>(plugins: [VerbosePlugin(verbose: true)])
        globalProvider = provider
        return provider.rx
            .request(request, callbackQueue: DispatchQueue.main).observeOn(MainScheduler.instance)
            .filterSuccessfulStatusAndRedirectCodes()
            .map(T2.self)
            .catchError { error in
                if let moyaError = error as? MoyaError {
                    return Single.error(moyaError)
                } else if let chooseError = error as? ErrorResponse {
                    return Single.error(chooseError)
                } else {
                    return Single.error(error)
                }
            }
    }

    
    func deleteRequest<T1: TargetType>(_ request: T1) -> Single<Response> {
        let provider = MoyaProvider<T1>(plugins: [VerbosePlugin(verbose: true)])
        globalProvider = provider
            return provider.rx
                    .request(request)
                    .filterSuccessfulStatusAndRedirectCodes()
                    .catchError { error in
                        if let moyaError = error as? MoyaError {
                            return Single.error(moyaError)
                        } else if let chooseError = error as? ErrorResponse {
                            return Single.error(chooseError)
                        } else {
                            return Single.error(error)
                        }
                     }
    }
    
    
    
}

// MARK: - ChooseServiceProtocol implementation
extension NetworkService {
    func getChooseByID(id: Int64) -> Single<ChooseResponse> {
        return request(GetChooseByIdAPI(token: token, id: id))
    }
    
    func answerChoose(id: Int64, model: ChooseAnswerRequest) -> Single<ChooseResponse> {
        return request(AnswerChooseAPI(token: token, requestData: model, id: id))
    }
    
    func deleteChooses(model: ChooseDeleteRequest) -> Single<Response> {
        return deleteRequest(DeleteChooseAPI(token: token, requestData: model))
    }
    
    func postChoose(model: PostChooseRequest) -> Single<PostChooseResponse> {
        return request(PostChooseAPI(token: token, requestData: model))
    }
    
    func getMyChooses(model: PaginationModel) -> Single<MyChooseList> {
        return request(GetOwnChoosesAPI(token: token, requestData: model))
    }
    
    func getProfile() -> Single<ProfileChoose> {
        return request(GetOwnProfileAPI(token: token))
    }
    
    func getChooses(limit: Int) -> Single<NewChooseList> { return request(GetChoosesAPI(token: token, requestData: limit)) }
    
}
struct VerbosePlugin: PluginType {
    let verbose: Bool

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        #if DEBUG
        print(request.url!)
        if let body = request.httpBody, let str = String(data: body, encoding: .utf8) {
            if verbose {
                print("request to send: \(str))")
            }
        }
        #endif
        return request
    }

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        #if DEBUG
        switch result {
        case .success(let body):
            if verbose {
                print("Response:")
                if let json = try? JSONSerialization.jsonObject(with: body.data, options: .mutableContainers) {
                    print(json)
                } else {
                    let response = String(data: body.data, encoding: .utf8)!
                    print(response)
                }
            }
        case .failure( _):
            break
        }
        #endif
    }

}
