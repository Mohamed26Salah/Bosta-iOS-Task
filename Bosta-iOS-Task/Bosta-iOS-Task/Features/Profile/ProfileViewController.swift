//
//  ViewController.swift
//  Bosta-iOS-Task
//
//  Created by Mohamed Salah on 18/11/2024.
//

import UIKit
import Combine

class ProfileViewController: UIViewController {
    private var viewModel: ProfileViewModel = ProfileViewModel()
    private var cancellables = Set<AnyCancellable>()

    private let profileView = ProfileUIView()
    
    override func loadView() {
        self.view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupTableViewDelegates()
        viewModel.loadUserAndAlbums()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always 
    }
    
    private func setupTableViewDelegates() {
        profileView.tableView.dataSource = self
        profileView.tableView.delegate = self
    }

}

//MARK: - SetUp UI -

extension ProfileViewController {
    private func setupUI() {
        self.title = "Profile"
        view.backgroundColor = .white
    }
}



//MARK: - Table View -

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.albums.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath)
        cell.textLabel?.text = viewModel.albums[indexPath.row].title
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAlbum = viewModel.albums[indexPath.row]
        let photosVC = PhotosViewController(albumId: selectedAlbum.id)
        navigationController?.pushViewController(photosVC, animated: true)
    }
}


//MARK: - Subscribe To Publishers -

extension ProfileViewController {
    private func setupBindings() {
        viewModel.$user
            .compactMap { $0?.name }
            .receive(on: RunLoop.main)
            .assign(to: \.text, on: profileView.userName)
            .store(in: &cancellables)

        viewModel.$user
            .compactMap { $0?.address }
            .map { "\($0.city), \($0.street), \($0.suite)" }
            .receive(on: RunLoop.main)
            .assign(to: \.text, on: profileView.userAddress)
            .store(in: &cancellables)
        
        viewModel.$albums
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else {return}
                self.profileView.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

