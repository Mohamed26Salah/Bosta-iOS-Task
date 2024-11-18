//
//  PhotosViewController.swift
//  Bosta-iOS-Task
//
//  Created by Mohamed Salah on 18/11/2024.
//

import Foundation
import UIKit
import Combine
import SDWebImage

class PhotosViewController: UIViewController {
    private var viewModel: PhotosViewModel
    private var cancellables = Set<AnyCancellable>()
    private let searchTextSubject: CurrentValueSubject<String?, Never> = .init(nil)
    
    private let photosView = PhotosUIView()
   

    init(albumId: Int) {
        self.viewModel = PhotosViewModel(albumId: albumId)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = photosView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupSearchBarView()
        setupCollectionView()
        viewModel.loadPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)

        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupSearchBarView() {
        photosView.searchBar.delegate = self
    }
    private func setupCollectionView() {
        photosView.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        photosView.collectionView.dataSource = self
    }
    
    
}

//MARK: Search Bar

extension PhotosViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTextSubject.send(searchText)
    }
}

//MARK: - SetUp UI -

extension PhotosViewController {
    private func setupUI() {
        view.backgroundColor = .white
    }

}

//MARK: - Collection View -

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredPhotos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
        let photo = viewModel.filteredPhotos[indexPath.item]
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        cell.backgroundView = imageView
        
        if let url = URL(string: photo.url) {
            imageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
        }
        
        return cell
    }
}

//MARK: - Subscribe To Publishers -
extension PhotosViewController {
    private func setupBindings() {
        searchTextSubject
            .compactMap({$0})
            .assign(to: \.searchText, on: viewModel)
            .store(in: &cancellables)
        
        viewModel.$filteredPhotos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.photosView.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}
