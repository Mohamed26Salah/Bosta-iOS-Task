//
//  Album.swift
//  Bosta-iOS-Task
//
//  Created by Mohamed Salah on 18/11/2024.
//

import Foundation

// MARK: - Album
struct Album: Codable {
    var userID: Int
    var id: Int
    var title: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id = "id"
        case title = "title"
    }
}

typealias Albums = [Album]
