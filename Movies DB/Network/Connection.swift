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
    
    
    
    func getMovies(orderBy order:MovieOrder, successCallback:(([Movie]) -> Void)?, failureCallback:((String) -> Void)?){
        let endpoint: Endpoint = .getMovieList(order: order)
        guard let reachability = self.reachability else{
            failureCallback!(ConnectionError.serverNotAvailable.getErrorString())
            return
        }
        do {
            try reachability.startNotifier()
            switch reachability.connection {
            case .wifi, .cellular :
                AF.request(endpoint.request).validate(statusCode: [200]).validate(contentType: ["application/json"]).responseJSON { (response) in
                    print("Response: \n \(String(describing: response.result))")
                    do{
                        if let data = response.data {
                            let json = String(data: data, encoding: String.Encoding.utf8)
                            print("Failure Response: \(String(describing: json))")
                        }
                        
                        switch response.result {
                        case .success:
                            print("Validation Successful")
                            if let movieList = try? JSONDecoder().decode([Movie].self, from: response.data!) {
                                if(successCallback != nil){
                                    successCallback!(movieList)
                                }
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
                        if(failureCallback != nil){
                            failureCallback!(ConnectionError.badResponse.getErrorString())
                        }
                    } catch ConnectionError.serverNotAvailable{
                        if(failureCallback != nil){
                            failureCallback!(ConnectionError.serverNotAvailable.getErrorString())
                        }
                    } catch {
                        if(failureCallback != nil){
                            failureCallback!(ConnectionError.unknownError.getErrorString())
                        }
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
            if(failureCallback != nil){
                failureCallback!(ConnectionError.noInternetConnection.getErrorString())
            }
        }
        catch {
            if(failureCallback != nil){
                failureCallback!(ConnectionError.unknownError.getErrorString())
            }
        }
    }
    
    func getMovie(withId id: Int, successCallback:((Movie) -> Void)?, failureCallback:((String) -> Void)?){
        let endpoint: Endpoint = .getMovie(id: id)
        
        guard let reachability = self.reachability else{
            failureCallback!(ConnectionError.serverNotAvailable.getErrorString())
            return
        }
        do {
            try reachability.startNotifier()
            switch reachability.connection {
            case .wifi, .cellular :
                AF.request(endpoint.request).validate(statusCode: [200]).validate(contentType: ["application/json"]).responseJSON { (response) in
                    print("Response: \n \(String(describing: response.result))")
                    do{
                        if let data = response.data {
                            let json = String(data: data, encoding: String.Encoding.utf8)
                            print("Failure Response: \(String(describing: json))")
                        }
                        
                        switch response.result {
                        case .success:
                            print("Validation Successful")
                            if let movie = try? JSONDecoder().decode(Movie.self, from: response.data!) {
                                if(successCallback != nil){
                                    successCallback!(movie)
                                }
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
                        if(failureCallback != nil){
                            failureCallback!(ConnectionError.badResponse.getErrorString())
                        }
                    } catch ConnectionError.serverNotAvailable{
                        if(failureCallback != nil){
                            failureCallback!(ConnectionError.serverNotAvailable.getErrorString())
                        }
                    } catch {
                        if(failureCallback != nil){
                            failureCallback!(ConnectionError.unknownError.getErrorString())
                        }
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
            if(failureCallback != nil){
                failureCallback!(ConnectionError.noInternetConnection.getErrorString())
            }
        }
        catch {
            if(failureCallback != nil){
                failureCallback!(ConnectionError.unknownError.getErrorString())
            }
        }
    }
    
    func getTrailers(forMovieId movieId: Int, successCallback:(([Trailer]) -> Void)?, failureCallback:((String) -> Void)?){
        let endpoint: Endpoint = .getTrailers(movieId: movieId)
        guard let reachability = self.reachability else{
            failureCallback!(ConnectionError.serverNotAvailable.getErrorString())
            return
        }
        do {
            try reachability.startNotifier()
            switch reachability.connection {
            case .wifi, .cellular :
                
                AF.request(endpoint.request).validate(statusCode: [200]).validate(contentType: ["application/json"]).responseJSON { (response) in
                    print("Response: \n \(String(describing: response.result))")
                    do{
                        if let data = response.data {
                            let json = String(data: data, encoding: String.Encoding.utf8)
                            print("Failure Response: \(String(describing: json))")
                        }
                        
                        switch response.result {
                        case .success:
                            print("Validation Successful")
                            if let trailerResponse = try? JSONDecoder().decode(TrailerResponse.self, from: response.data!){
                                let trailerList = trailerResponse.trailers
                                if(successCallback != nil){
                                    successCallback!(trailerList)
                                }
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
                        if(failureCallback != nil){
                            failureCallback!(ConnectionError.badResponse.getErrorString())
                        }
                    } catch ConnectionError.serverNotAvailable{
                        if(failureCallback != nil){
                            failureCallback!(ConnectionError.serverNotAvailable.getErrorString())
                        }
                    } catch {
                        if(failureCallback != nil){
                            failureCallback!(ConnectionError.unknownError.getErrorString())
                        }
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
            if(failureCallback != nil){
                failureCallback!(ConnectionError.noInternetConnection.getErrorString())
            }
        }
        catch {
            if(failureCallback != nil){
                failureCallback!(ConnectionError.unknownError.getErrorString())
            }
        }
    }
}
