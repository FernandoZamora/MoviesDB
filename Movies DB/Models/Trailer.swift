//
//  Trailer.swift
//  Movies DB
//
//  Created by Fernando Zamora on 11/01/21.
//

import Foundation

struct Trailer: Codable {
    let id: String
    let key: String
    let name: String
}

struct TrailerResponse: Codable{
    let id: Int
    let trailers: [Trailer]
    
    enum CodingKeys: String, CodingKey {
        case id
        case trailers = "results"
    }
}
