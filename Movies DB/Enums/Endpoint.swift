//
//  Endpoint.swift
//  Movies DB
//
//  Created by Fernando Zamora on 11/01/21.
//

import Foundation

enum Endpoint{
    case getMovieList(order: MovieOrder, page: Int)
    case getMovie(id: Int)
    case getTrailers(movieId: Int)
    case getVideoURL(key: String)
    case getPosterURL(path: String)
    
    var url: String {
        get {
          switch self{
          case .getMovieList(let order, let page): return "\(ConnectionSetup.baseURL)/movie/\(order.rawValue)?api_key=\(ConnectionSetup.apiKey)&language=\(Language.getInstance().currentLanguage.rawValue)&page=\(page)"
          case .getMovie(let id): return "\(ConnectionSetup.baseURL)/movie/\(id)?api_key=\(ConnectionSetup.apiKey)&language=\(Language.getInstance().currentLanguage.rawValue)"
          case .getTrailers(let movieId): return "\(ConnectionSetup.baseURL)/movie/\(movieId)/videos?api_key=\(ConnectionSetup.apiKey)&language=\(Language.getInstance().currentLanguage.rawValue)"
          case .getVideoURL(let key): return "https://www.youtube.com/watch?v=\(key)"
          case .getPosterURL(let path): return "https://image.tmdb.org/t/p/w500/\(path)"
          }
        }
      }
    
    var httpMethod: String {
        get {
          switch self {
          case .getMovieList(_,_), .getMovie(_), .getTrailers(_), .getPosterURL(_):  return "get"
          default: return "get"
          }
        }
      }
    
    var request: URLRequest {
        get {
            var request = URLRequest(url: URL(string: self.url)!)
          request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
          request.httpMethod = self.httpMethod
            return request
        }
      }
}
