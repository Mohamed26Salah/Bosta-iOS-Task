//
//  URLRequestBuilder.swift
//  Bosta-iOS-Task
//
//  Created by Mohamed Salah on 18/11/2024.
//
import Foundation
import Moya

enum JSONPlaceholderAPI {
    case users
    case albums(userId: Int)
    case photos(albumId: Int)
}

extension JSONPlaceholderAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }
    
    var path: String {
        switch self {
        case .users:
            return "/users"
        case .albums:
            return "/albums"
        case .photos:
            return "/photos"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .users, .albums, .photos:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .users:
            return .requestPlain
        case .albums(let userId):
            return .requestParameters(parameters: ["userId": userId], encoding: URLEncoding.default)
        case .photos(let albumId):
            return .requestParameters(parameters: ["albumId": albumId], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
}
