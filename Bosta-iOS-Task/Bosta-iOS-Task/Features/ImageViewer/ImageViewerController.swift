//
//  PhotoManagerViewController.swift
//  Bosta-iOS-Task
//
//  Created by Mohamed Salah on 18/11/2024.
//

import UIKit

class ImageViewerController: UIViewController {
    
    private var imageUrl: URL?
    private let imageViewer = ImageViewerUIView()

    init(imageUrl: URL) {
        self.imageUrl = imageUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = imageViewer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadImage()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        imageViewer.scrollView.delegate = self
        setupNavigationBar()
    }
    
    private func loadImage() {
        guard let imageUrl = imageUrl else { return }
        imageViewer.imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(systemName: "photo"))
    }
    
}

// MARK: - Share Image -

extension ImageViewerController {
    private func setupNavigationBar() {
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareImage))
        navigationItem.rightBarButtonItem = shareButton
    }
    
    @objc private func shareImage() {
        guard let image = imageViewer.imageView.image else { return }
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
}

// MARK: - Zoom Inside Scroll View -

extension ImageViewerController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageViewer.imageView
    }
}
