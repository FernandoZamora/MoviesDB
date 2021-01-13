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
            self.descriptionLabel.text = movie.description
            let posterURL = Endpoint.getPosterURL(path: movie.poster).url
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
        } failureCallback: { (errorString) in
            let alert = UIAlertController(title: nil, message: errorString, preferredStyle: .alert)
            let actionBtn = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(actionBtn)
            self.present(alert, animated: true, completion: nil)
        }
        connection.getTrailers(forMovieId: self.movieId) { (trailerList) in
            self.trailers = trailerList
            self.trailerTableView.reloadData()
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
    
    
}
