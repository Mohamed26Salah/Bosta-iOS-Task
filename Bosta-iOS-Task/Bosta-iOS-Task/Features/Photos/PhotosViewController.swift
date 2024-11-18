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

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        let spacing: CGFloat = 10
        let itemsPerRow: CGFloat = 3
        let totalSpacing = spacing * (itemsPerRow - 1)
        let itemWidth = (screenWidth - totalSpacing) / itemsPerRow
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search photos by title"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    init(albumId: Int) {
        self.viewModel = PhotosViewModel(albumId: albumId)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.loadPhotos()
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
        
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(searchBar)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collectionView.dataSource = self
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}
