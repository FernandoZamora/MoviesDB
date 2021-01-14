//
//  Movie.swift
//  Movies DB
//
//  Created by Fernando Zamora on 11/01/21.
//

import Foundation

struct Movie: Codable{
    let id: Int
    let title: String
    let originalTitle: String
    let description: String
    let release: String
    let duration: Int?
    let score: Double
    let poster: String
    let hasTrailers: Bool
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "title"
        case originalTitle = "original_title"
        case description = "overview"
        case duration = "runtime"
        case release = "release_date"
        case score = "vote_average"
        case poster = "poster_path"
        case hasTrailers = "video"
    }
}

struct MovieFilterResponse: Codable{
    let page: Int
    let movies: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
