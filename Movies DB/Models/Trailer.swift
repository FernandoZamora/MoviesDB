//
//  Trailer.swift
//  Movies DB
//
//  Created by Fernando Zamora on 11/01/21.
//

import Foundation

struct Trailer: Codable {
    let id: Int
    let key: String
    let name: String
}

struct TrailerResponse: Codable{
    let id: Int
    let trailers: [Trailer]
}
