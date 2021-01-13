//
//  Registrable.swift
//  Movies DB
//
//  Created by Fernando Zamora on 11/01/21.
//

import UIKit

protocol Registrable {}

extension Registrable where Self:UITableViewCell {
    static func register(in tableView: UITableView) {
        tableView.register(UINib(nibName: String(describing: Self.self), bundle: nil), forCellReuseIdentifier: String(describing: Self.self))
    }
}
extension Registrable where Self:UICollectionViewCell {
    static func register(in collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: String(describing: Self.self), bundle: nil), forCellWithReuseIdentifier: String(describing: Self.self))
    }
}
