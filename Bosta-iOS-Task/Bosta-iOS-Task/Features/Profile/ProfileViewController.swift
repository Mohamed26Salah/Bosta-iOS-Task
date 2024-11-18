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

    private let tableView = UITableView()
    private let userName = UILabel()
    private let userAddress = UILabel()

    
//    override func loadView() {
//        self.view = PorfileUIView
//    }
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.loadUserAndAlbums()
    }

    func inject(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }

}

//MARK: - SetUp UI -

extension ProfileViewController {
    private func setupUI() {
        self.title = "Profile"
        view.backgroundColor = .white

        // User Label
        userName.font = UIFont.boldSystemFont(ofSize: 24)
        userName.textAlignment = .left
        userName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userName)

        
        // User Label
        userAddress.font = UIFont.boldSystemFont(ofSize: 16)
        userAddress.textAlignment = .left
        userAddress.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userAddress)
        
        
        // TableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AlbumCell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)

        // Layout
        NSLayoutConstraint.activate([
            userName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            userName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            userAddress.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 16),
            userAddress.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userAddress.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: userAddress.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: userName)
            .store(in: &cancellables)

        viewModel.$user
            .compactMap { $0?.address }
            .map { "\($0.city), \($0.street), \($0.suite)" }
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: userAddress)
            .store(in: &cancellables)
        
        viewModel.$albums
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else {return}
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

