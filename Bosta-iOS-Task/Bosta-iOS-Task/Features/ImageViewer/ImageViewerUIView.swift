//
//  ImageViewerUIView.swift
//  Bosta-iOS-Task
//
//  Created by Mohamed Salah on 18/11/2024.
//

import UIKit
import SwiftUI

class ImageViewerUIView: UIView {
    private let ImageViewerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.maximumZoomScale = 4.0
        scrollView.minimumZoomScale = 1.0
        return scrollView
    }()
    private let imageViewInsideScrollView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .white
        setupMainImagerViewer()
        setupScrollView()
        setupViewInsideScrollView()
        setupImageView()
    }
    
    //MARK: Setup Main Image Viewer
    func setupMainImagerViewer() {
        addSubview(ImageViewerView)
        NSLayoutConstraint.activate([
            ImageViewerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            ImageViewerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            ImageViewerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            ImageViewerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    //MARK: Setup Scroll View
    func setupScrollView() {
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: ImageViewerView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: ImageViewerView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: ImageViewerView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: ImageViewerView.bottomAnchor)
        ])
    }
    
    //MARK: Setup View Inside Scroll View
    func setupViewInsideScrollView() {
        scrollView.addSubview(imageViewInsideScrollView)
        
        let hconst = imageViewInsideScrollView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 2)
        hconst.isActive = true
        hconst.priority = UILayoutPriority(250)
        
        NSLayoutConstraint.activate([
            imageViewInsideScrollView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageViewInsideScrollView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageViewInsideScrollView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageViewInsideScrollView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            imageViewInsideScrollView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    //MARK: Setup Image View
    func setupImageView() {
        imageViewInsideScrollView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: imageViewInsideScrollView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: imageViewInsideScrollView.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: imageViewInsideScrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: imageViewInsideScrollView.heightAnchor)
        ])
    }
}
struct ImageViewerViewController_Previews: PreviewProvider {
    
    static var previews: some View {
        UIViewPreview {
            ImageViewerUIView()
        }
    }
}
