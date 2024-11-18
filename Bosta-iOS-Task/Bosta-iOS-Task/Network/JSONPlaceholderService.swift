//
//  JJSONPlaceholderService.swift
//  Bosta-iOS-Task
//
//  Created by Mohamed Salah on 18/11/2024.
//
import Foundation
import Moya
import CombineMoya
import Combine

protocol JSONPlaceholderServiceProtocol {
    func fetchUsers() -> AnyPublisher<[User], Error>
    func fetchAlbums(for userId: Int) -> AnyPublisher<[Album], Error>
    func fetchPhotos(for albumId: Int) -> AnyPublisher<[Photo], Error>
}


class JSONPlaceholderService: JSONPlaceholderServiceProtocol {
    private let provider: MoyaProvider<JSONPlaceholderAPI>
    
    init(provider: MoyaProvider<JSONPlaceholderAPI> = MoyaProvider<JSONPlaceholderAPI>()) {
        self.provider = provider
    }
    
    func fetchUsers() -> AnyPublisher<[User], Error> {
        return provider.requestPublisher(.users)
            .map(\.data)
            .decode(type: [User].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchAlbums(for userId: Int) -> AnyPublisher<[Album], Error> {
        return provider.requestPublisher(.albums(userId: userId))
            .map(\.data)
            .decode(type: [Album].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchPhotos(for albumId: Int) -> AnyPublisher<[Photo], Error> {
        return provider.requestPublisher(.photos(albumId: albumId))
            .map(\.data)
            .decode(type: [Photo].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
