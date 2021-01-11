//
//  ConnectionError.swift
//  Movies DB
//
//  Created by Fernando Zamora on 11/01/21.
//

import Foundation

enum ConnectionError:Error{
    case badRequest
    case badResponse
    case serverNotAvailable
    case noInternetConnection
    case unknownError
    
    func getErrorString() -> String{
        switch self {
        case .badRequest, .badResponse, .serverNotAvailable, .unknownError:
            return "We are sorry, but the service is not available right now."
        case .noInternetConnection:
            return "It seems that your device is not connected to the internet, check your connection and try again please."
        }
    }
}
