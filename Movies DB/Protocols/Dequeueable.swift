//
//  Dequeueable.swift
//  Movies DB
//
//  Created by Fernando Zamora on 11/01/21.
//

import UIKit

protocol Dequeable {}

extension Dequeable where Self:UITableViewCell {
    static func dequeue(from tableView: UITableView) -> Self {
        return tableView.dequeueReusableCell(withIdentifier: String(describing: Self.self)) as! Self
    }
}
extension Dequeable where Self:UICollectionViewCell {
    static func dequeue(from collectionView: UICollectionView, for indexpath: IndexPath) -> Self {
        return collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: Self.self), for: indexpath) as! Self
    }
}
