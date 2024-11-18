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
    @Published var searchText: String = ""
    @Published private(set) var filteredPhotos: [Photo] = []
    @Published var error: String = ""
    @Published var showError: Bool = false
    
    private let albumId: Int
    private let service: JSONPlaceholderServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(albumId: Int, service: JSONPlaceholderServiceProtocol = JSONPlaceholderService()) {
        self.albumId = albumId
        self.service = service
        setupSearch()
    }

}

//MARK: - Api Calls -

extension PhotosViewModel {
    func loadPhotos() {
        service.fetchPhotos(for: albumId)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    print("Error fetching photos: \(error)")
                    self?.error = "Error fetching photos"
                    self?.showError = true
                }
            }, receiveValue: { [weak self] photos in
                guard let self = self else {return}
                self.photos = photos
                self.filteredPhotos = photos
            })
            .store(in: &cancellables)
    }
}

//MARK: - Subscribe To Publishers -

extension PhotosViewModel {
    private func setupSearch() {
            $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
                .removeDuplicates()
                .map { [weak self] query in
                    guard let self = self else {return []}
                    return query.isEmpty ? self.photos : self.photos.filter { $0.title.localizedCaseInsensitiveContains(query) }
                }
                .assign(to: &$filteredPhotos)
        }

}
