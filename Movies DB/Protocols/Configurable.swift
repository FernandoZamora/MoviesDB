//
//  Configurable.swift
//  Movies DB
//
//  Created by Fernando Zamora on 11/01/21.
//

import UIKit

protocol Configurable {
    associatedtype DataType
    
    func configure(with data:DataType)
}
