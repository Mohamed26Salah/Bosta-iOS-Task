//
//  AlbumUser.swift
//  Bosta-iOS-Task
//
//  Created by Mohamed Salah on 18/11/2024.
//
import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var albums: [Album] = []
    @Published var error: String = ""
    @Published var showError: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    let service: JSONPlaceholderServiceProtocol

    init(service: JSONPlaceholderServiceProtocol = JSONPlaceholderService()) {
        self.service = service
    }


}

//MARK: - Api Calls -

extension ProfileViewModel {
    func loadUserAndAlbums() {
        service.fetchUsers()
            .compactMap { $0.randomElement() }
            .flatMap { [weak self] user -> AnyPublisher<[Album], Error> in
                self?.user = user
                return self?.service.fetchAlbums(for: user.id) ?? Empty().eraseToAnyPublisher()
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    print("Error fetching user or albums: \(error)")
                    self?.error = "Error fetching user or albums"
                    self?.showError = true
                }
            }, receiveValue: { [weak self] albums in
                guard let self = self else {return}
                self.albums = albums
            })
            .store(in: &cancellables)
    }
}
