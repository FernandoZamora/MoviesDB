//
//  MovieListViewController.swift
//  Movies DB
//
//  Created by Fernando Zamora on 11/01/21.
//

import UIKit

class MovieListViewController: UIViewController {

    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    var movies: [Movie] = []
    var movieOrder: MovieOrder = .latestReleases {
        didSet{
            switch movieOrder {
            case .latestReleases:
                self.title = "Latest Movies"
            case .mostPopular:
                self.title = "Popular Movies"
            case .topRated:
                self.title = "Top Rated Movies"
            }
        }
    }
    var selectedMovie: Movie? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        MovieCollectionViewCell.register(in: movieCollectionView)
        
        movieOrder = .latestReleases
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let connection = Connection.getInstance()
        connection.getMovies(orderBy: movieOrder) { (movieList) in
            self.movies = movieList
            self.movieCollectionView.reloadData()
        } failureCallback: { (errorString) in
            let alert = UIAlertController(title: nil, message: errorString, preferredStyle: .alert)
            let actionBtn = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(actionBtn)
            self.present(alert, animated: true, completion: nil)
        }
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? MovieDetailViewController,
           let movie = selectedMovie{
            detailVC.movieId = movie.id
        }
    }
}
extension MovieListViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        selectedMovie = movie
        performSegue(withIdentifier: "showDetail", sender: self)
    }
}
extension MovieListViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = movies[indexPath.row]
        let movieCell = MovieCollectionViewCell.dequeue(from: collectionView, for: indexPath)
        movieCell.configure(with: movie)
        return movieCell
    }
}
extension MovieListViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/3.0
        let height = width*1.33
        return CGSize(width: width, height: height)
    }
}
