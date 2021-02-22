//
//  Connection.swift
//  Movies DB
//
//  Created by Fernando Zamora on 11/01/21.
//

import Foundation
import UIKit
import Alamofire
import Reachability

class Connection {
    private static let instance = Connection()
    var reachability: Reachability?
    
    required internal init(){
        do{
            self.reachability = try Reachability(hostname: ConnectionSetup.baseURL)
        }
        catch{
            print("Not reachable")
        }
    }
    
    class func getInstance() -> Connection {
        return Connection.instance
    }
    
    
    
    func getMovies(orderBy order:MovieOrder, page: Int = 1, successCallback:(([Movie]) -> Void)?, failureCallback:((String) -> Void)?){
        let endpoint: Endpoint = .getMovieList(order: order, page: page)
        self.getContent(withEndpoint: endpoint) { (response:MovieFilterResponse) in
            let movieList = response.movies
            successCallback?(movieList)
        } failureCallback: { (errorMessage) in
            failureCallback?(errorMessage)
        }
    }
    
    func getMovie(withId id: Int, successCallback:((Movie) -> Void)?, failureCallback:((String) -> Void)?){
        let endpoint: Endpoint = .getMovie(id: id)
        self.getContent(withEndpoint: endpoint) { (response:Movie) in
            successCallback?(response)
        } failureCallback: { (errorMessage) in
            failureCallback?(errorMessage)
        }
    }
    
    func getTrailers(forMovieId movieId: Int, successCallback:(([Trailer]) -> Void)?, failureCallback:((String) -> Void)?){
        let endpoint: Endpoint = .getTrailers(movieId: movieId)
        self.getContent(withEndpoint: endpoint) { (response:TrailerResponse) in
            let trailerList = response.trailers
            successCallback?(trailerList)
        } failureCallback: { (errorMessage) in
            failureCallback?(errorMessage)
        }
    }
    
    private func getContent<Response:Codable>(withEndpoint endpoint:Endpoint, successCallback:((Response) -> Void)?, failureCallback:((String) -> Void)? ){
        guard let reachability = self.reachability else{
            failureCallback?(ConnectionError.serverNotAvailable.getErrorString())
            return
        }
        do {
            try reachability.startNotifier()
            switch reachability.connection {
            case .wifi, .cellular :
                
                AF.request(endpoint.request).validate(statusCode: [200]).validate(contentType: ["application/json"]).responseJSON { (response) in
                    print("Response: \n \(String(describing: response.result))")
                    do{
                        switch response.result {
                        case .success:
                            print("Validation Successful")
                            if let responseData = try? JSONDecoder().decode(Response.self, from: response.data!){
                                successCallback?(responseData)
                            }
                            else{
                                throw ConnectionError.badResponse
                            }
                        case let .failure(error):
                            print(error)
                            if let statusCode = response.response?.statusCode, statusCode == 500 {
                                throw ConnectionError.serverNotAvailable
                            }
                            else{
                                throw ConnectionError.unknownError
                            }
                        }
                    } catch ConnectionError.badResponse{
                        failureCallback?(ConnectionError.badResponse.getErrorString())
                    } catch ConnectionError.serverNotAvailable{
                        failureCallback?(ConnectionError.serverNotAvailable.getErrorString())
                    } catch {
                        failureCallback?(ConnectionError.unknownError.getErrorString())
                    }
                }
            case .none:
                reachability.stopNotifier()
                throw ConnectionError.noInternetConnection
            case .unavailable:
                reachability.stopNotifier()
                throw ConnectionError.noInternetConnection
            }
            reachability.stopNotifier()
        } catch ConnectionError.noInternetConnection{
            failureCallback?(ConnectionError.noInternetConnection.getErrorString())
        }
        catch {
            failureCallback?(ConnectionError.unknownError.getErrorString())
        }
    }
}
