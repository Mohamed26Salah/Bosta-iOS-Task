//
//  PorfileUIView.swift
//  Bosta-iOS-Task
//
//  Created by Mohamed Salah on 18/11/2024.
//

import UIKit
import SwiftUI

final class ProfileUIView: UIView {
    let userName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let userAddress: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AlbumCell")
        return tableView
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

        addSubview(userName)
        addSubview(userAddress)
        addSubview(tableView)

        NSLayoutConstraint.activate([
            userName.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            userName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            userName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            userAddress.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 16),
            userAddress.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            userAddress.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: userAddress.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

struct ProfileViewController_Previews: PreviewProvider {
    
    static var previews: some View {
        UIViewPreview {
            ProfileUIView()
        }
    }
}
