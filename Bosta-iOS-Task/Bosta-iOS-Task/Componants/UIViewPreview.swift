//
//  UIViewPreview.swift
//  Bosta-iOS-Task
//
//  Created by Mohamed Salah on 18/11/2024.
//

import SwiftUI

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
