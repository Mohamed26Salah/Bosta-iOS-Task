//
//  PhotosViewModel.swift
//  Bosta-iOS-Task
//
//  Created by Mohamed Salah on 18/11/2024.
//
import Foundation
import Combine

class PhotosViewModel: ObservableObject {
    @Published var photos: [Photo] = []

    private let albumId: Int
    private let service: JSONPlaceholderServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(albumId: Int, service: JSONPlaceholderServiceProtocol = JSONPlaceholderService()) {
        self.albumId = albumId
        self.service = service
    }

}

//MARK: - Api Calls -

extension PhotosViewModel {
    func loadPhotos() {
        service.fetchPhotos(for: albumId)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error fetching photos: \(error)")
                }
            }, receiveValue: { [weak self] photos in
                self?.photos = photos
            })
            .store(in: &cancellables)
    }
}
