//
//  Endpoint.swift
//  Movies DB
//
//  Created by Fernando Zamora on 11/01/21.
//

import Foundation

enum Endpoint{
    case getMovieList(order: MovieOrder)
    case getMovie(id: Int)
    case getTrailers(movieId: Int)
    case getVideoURL(key: String)
    
    var url: String {
        get {
          switch self{
          case .getMovieList(let order): return "\(ConnectionSetup.baseURL)/movie/\(order.rawValue)?api_key=\(ConnectionSetup.apiKey)&language=\(Language.getInstance().currentLanguage.rawValue)"
          case .getMovie(let id): return "\(ConnectionSetup.baseURL)/movie/\(id)?api_key=\(ConnectionSetup.apiKey)&language=\(Language.getInstance().currentLanguage.rawValue)"
          case .getTrailers(let movieId): return "\(ConnectionSetup.baseURL)/movie/\(movieId)/videos?api_key=\(ConnectionSetup.apiKey)&language=\(Language.getInstance().currentLanguage.rawValue)"
          case .getVideoURL(let key): return "https://www.youtube.com/watch?v=\(key)"
          }
        }
      }
    
    var httpMethod: String {
        get {
          switch self {
          case .getMovieList(_), .getMovie(_), .getTrailers(_):  return "get"
          default: return "get"
          }
        }
      }
    
    var request: URLRequest {
        get {
            var request = URLRequest(url: URL(string: self.url)!)
          request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
          request.httpMethod = self.httpMethod
        }
      }
}
