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
    var movieOrder: MovieOrder = .topRated {
        didSet{
            switch movieOrder {
            case .upcoming:
                self.title = "movie_list_title1".localized()
            case .mostPopular:
                self.title = "movie_list_title2".localized()
            case .topRated:
                self.title = "movie_list_title3".localized()
            }
        }
    }
    var selectedMovie: Movie? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        MovieCollectionViewCell.register(in: movieCollectionView)
        
        movieOrder = .upcoming
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image:UIImage(systemName:"gearshape"), style: .plain, target: self, action: #selector(settingsTapped))
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
    
    @objc func settingsTapped(){
        let menu = UIAlertController(title: "menu_title".localized(), message: "menu_instructions".localized(), preferredStyle: .actionSheet)
        let changeLanguageBtn = UIAlertAction(title: "menu_change_language_button".localized(), style: .default){_ in
            switch Language.getInstance().currentLanguage{
                case .english: Language.getInstance().currentLanguage = .spanish
                case .spanish: Language.getInstance().currentLanguage = .english
            }
            switch self.movieOrder {
                case .upcoming:
                    self.title = "movie_list_title1".localized()
                case .mostPopular:
                    self.title = "movie_list_title2".localized()
                case .topRated:
                    self.title = "movie_list_title3".localized()
            }
            self.viewWillAppear(true)
        }
        menu.addAction(changeLanguageBtn)
        let changeUpcomingBtn = UIAlertAction(title: "menu_change_upcoming_button".localized(), style: .default){_ in
            self.movieOrder = .upcoming
            self.viewWillAppear(true)
        }
        menu.addAction(changeUpcomingBtn)
        let changePopularBtn = UIAlertAction(title: "menu_change_popular_button".localized(), style: .default){_ in
            self.movieOrder = .mostPopular
            self.viewWillAppear(true)
        }
        menu.addAction(changePopularBtn)
        let changeTopRatedBtn = UIAlertAction(title: "menu_change_top_rated_button".localized(), style: .default){_ in
            self.movieOrder = .topRated
            self.viewWillAppear(true)
        }
        menu.addAction(changeTopRatedBtn)
        self.present(menu, animated: true, completion: nil)
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
