//
//  PorfileUIView.swift
//  Bosta-iOS-Task
//
//  Created by Mohamed Salah on 18/11/2024.
//

import UIKit
import SwiftUI

final class PorfileUIView: UIView {
    private let titleLabel = UILabel()
    private let tableView = UITableView()
      
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
          
          // Title Label
          titleLabel.text = "Home"
          titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
          titleLabel.textAlignment = .center
          titleLabel.translatesAutoresizingMaskIntoConstraints = false
          addSubview(titleLabel)
          
          // TableView
          tableView.translatesAutoresizingMaskIntoConstraints = false
          tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
          addSubview(tableView)
          
          // Layout Constraints
          NSLayoutConstraint.activate([
              titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
              titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
              titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
              
              tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
              tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
              tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
              tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
          ])
      }
}

struct UIViewPreview: UIViewRepresentable {
    let build: () -> UIView
    init(_ build: @escaping () -> UIView) {
        self.build = build
    }
    
    func makeUIView(context: Context) -> some UIView {
        build()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
}

struct PreviewViewController_Previews: PreviewProvider {
    
    static var previews: some View {
        UIViewPreview {
            PorfileUIView()
        }
    }
}
