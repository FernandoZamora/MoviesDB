//
//  MovieCollectionViewCell.swift
//  Movies DB
//
//  Created by Fernando Zamora on 11/01/21.
//

import UIKit
import Kingfisher

class MovieCollectionViewCell: UICollectionViewCell, Registrable, Dequeable {
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}

extension MovieCollectionViewCell: Configurable{
    typealias DataType = Movie
    func configure(with data: Movie) {
        let posterURL = Endpoint.getPosterURL(path: data.poster).url
        if let url = URL(string: posterURL) {
            self.posterImageView.kf.indicatorType = .activity
            self.posterImageView.kf.setImage(with: url,
                                             placeholder: UIImage(named: "placeholderImage"),
                                             options: [
                                                 .scaleFactor(UIScreen.main.scale),
                                                 .transition(.fade(1)),
                                                 .cacheOriginalImage
                                             ])
        }
        else{
            self.posterImageView.image = UIImage(named: "placeholderImage")
        }
    }
}
