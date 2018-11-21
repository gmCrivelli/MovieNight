//
//  Movie.swift
//  MovieNight
//
//  Created by Gustavo De Mello Crivelli on 06/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//
import Foundation

struct JMovie: Codable {
    let title: String
    let categories: [String]?
    let duration: String?
    let rating: Double?
    let summary: String?
    let image: String?
    let itemType: ItemType?
    let items: [JMovie]?
    
    enum CodingKeys: String, CodingKey {
        case title
        case categories
        case duration
        case rating
        case summary = "description"
        case image
        case itemType
        case items
    }
}

enum ItemType: String, Codable {
    case movie = "movie"
    case list = "list"
}
