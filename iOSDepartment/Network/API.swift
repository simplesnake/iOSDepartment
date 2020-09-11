//
//  API.swift
//  iOSDepartment
//
//  Created by Строев Александр on 11.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

import Foundation
import Moya

class GetOwnProfileAPI: BaseTarget<EmptyRequest> {

    init(token: String, requestData: EmptyRequest? = nil) {
        
        super.init(token: token, requestData: requestData)
        self.path = "/user/profile/my"
    }
}

class GetChooseByIdAPI: BaseTarget<EmptyRequest> {
    init(token: String, requestData: EmptyRequest? = nil, id: Int64) {
        super.init(token: token, requestData: requestData)
        self.path = "/user/choose/\(id)"
    }
}

class PostChooseAPI: BaseTarget<PostChooseRequest> {
    init(token: String, requestData: PostChooseRequest? = nil) {
        
        super.init(token: token, requestData: requestData)
        self.path = "/user/choose"
        self.method = .post
    }
}

class GetOwnChoosesAPI: BaseTarget<PaginationModel> {
    
    init(token: String, requestData: PaginationModel? = nil) {
        super.init(token: token, requestData: requestData)
        self.path = "/user/choose/my"
    }
}

class GetChoosesAPI: BaseTarget<Int> {
    
    init(token: String, requestData: Int? = nil) {
        super.init(token: token, requestData: requestData)
        self.path = "/user/choose/new"
    }
}

class DeleteChooseAPI: BaseTarget<ChooseDeleteRequest> {
    init(token: String, requestData: ChooseDeleteRequest? = nil) {
        super.init(token: token, requestData: requestData)
        self.path = "/user/choose/delete"
        self.method = .delete
    }
}

class AnswerChooseAPI: BaseTarget<ChooseAnswerRequest> {
    init(token: String, requestData: ChooseAnswerRequest? = nil, id: Int64) {
        super.init(token: token, requestData: requestData)
        self.path = "/user/choose/\(id)/answer"
        self.method = .post
    }
}


class BaseChooseProvider<T: Encodable>: BaseTarget<T> {
}

class BaseTarget<T: Encodable>: TargetType {
    var path: String = ""
    
    var baseURL = URL(string: "https://dev.choose2020.tk/api")!
    var method: Moya.Method = .get
    var sampleData: Data = Data()
    var headers: [String : String]? {
        return ["Authorization": token]
    }
    var task: Task {
        return task(data: requestData)
    }
    var token: String
    
    var requestData: T?
    
    init(token: String, requestData: T?, method: Moya.Method = .get) {
        self.token = token
        self.requestData = requestData
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
}

class EmptyRequest: Encodable {}
