//
//  MovieDetailViewController.swift
//  Movies DB
//
//  Created by Fernando Zamora on 11/01/21.
//

import UIKit
import Kingfisher

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var fullTitleLabel: UILabel!
    @IBOutlet weak var originalTitle: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var trailerTableView: UITableView!
    @IBOutlet weak var trailerTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var trailersLabel: UILabel!
    
    
    var movieId: Int = -1
    var movie: Movie? = nil
    var trailers:[Trailer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trailerTableView.delegate = self
        trailerTableView.dataSource = self
        TrailerTableViewCell.register(in: trailerTableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        overviewLabel.text = "movie_overview".localized()
        trailersLabel.text = "movie_trailers".localized()
        
        let connection = Connection.getInstance()
        connection.getMovie(withId: self.movieId){ (movie) in
            self.movie = movie
            self.title = movie.title
            self.fullTitleLabel.text = movie.title
            self.originalTitle.text = movie.originalTitle
            
            var releaseYear = "Unknown"
            let releaseDateFormatter = DateFormatter()
            releaseDateFormatter.dateFormat = "yyyy-MM-dd"
            if let releaseDate = releaseDateFormatter.date(from: movie.release){
                let yearDateFormatter = DateFormatter()
                yearDateFormatter.dateFormat = "yyyy"
                releaseYear = yearDateFormatter.string(from: releaseDate)
            }
            
            self.yearLabel.text = releaseYear
            if let duration = movie.duration{
                self.durationLabel.text = "\(duration) min"
            }
            else{
                self.durationLabel.text = "- min"
            }
            self.scoreLabel.text = "\(movie.score)/10"
            if movie.isFavorite{
                self.favoriteBtn.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            }
            else{
                self.favoriteBtn.setImage(UIImage(systemName: "bookmark"), for: .normal)
            }
            self.descriptionLabel.text = movie.description
            
            guard let posterPath = movie.poster else{
                self.posterImageView.image = UIImage(named: "placeholderImage")
                return
            }
            let posterURL = Endpoint.getPosterURL(path: posterPath).url
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
        } failureCallback: { (errorString) in
            let alert = UIAlertController(title: nil, message: errorString, preferredStyle: .alert)
            let actionBtn = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(actionBtn)
            self.present(alert, animated: true, completion: nil)
        }
        connection.getTrailers(forMovieId: self.movieId) { (trailerList) in
            self.trailers = trailerList
            self.trailerTableView.reloadData()
            if self.trailers.count > 0{
                self.trailerTableViewHeightConstraint.constant = self.trailerTableView.contentSize.height
            }
            else{
                self.trailerTableViewHeightConstraint.constant = 0
            }
            self.view.layoutIfNeeded()
        } failureCallback: { (errorString) in
            let alert = UIAlertController(title: nil, message: errorString, preferredStyle: .alert)
            let actionBtn = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(actionBtn)
            self.present(alert, animated: true, completion: nil)
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}

extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trailers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let trailer = trailers[indexPath.row]
        let cell = TrailerTableViewCell.dequeue(from: tableView)
        cell.configure(with: trailer)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trailer = trailers[indexPath.row]
        
        
        if let url = URL(string: "youtube://\(trailer.key)"),
           UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
}
