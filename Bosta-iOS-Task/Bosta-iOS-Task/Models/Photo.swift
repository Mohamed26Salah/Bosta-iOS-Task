//
//  Photo.swift
//  Bosta-iOS-Task
//
//  Created by Mohamed Salah on 18/11/2024.
//

import Foundation

// MARK: - Photo
struct Photo: Codable {
    var albumID: Int
    var id: Int
    var title: String
    var url: String
    var thumbnailURL: String

    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id = "id"
        case title = "title"
        case url = "url"
        case thumbnailURL = "thumbnailUrl"
    }
}

typealias Photos = [Photo]
