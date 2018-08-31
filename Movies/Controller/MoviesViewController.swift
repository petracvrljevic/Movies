//
//  MoviesViewController.swift
//  Movies
//
//  Created by Petra Cvrljevic on 22/08/2018.
//  Copyright © 2018 Petra Cvrljevic. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import MBProgressHUD

class MoviesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var topRatedMovies = [Movie]()
    var popularMovies = [Movie]()
    
    var type: MovieType?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "movieCell")
        
        getTopRatedMovies()
        getPopularMovies()
    }
    
    func getTopRatedMovies() {
        getMovies(Helper.topRatedMoviesURL, .TopRated)
    }
    
    func getPopularMovies() {
        getMovies(Helper.popularMoviesURL, .Popular)
    }
    
    func getMovies(_ url: URL, _ movieType: MovieType) {
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        loadingNotification.isUserInteractionEnabled = false
        
        Alamofire.request(url, method: .get, parameters: Helper.params).responseJSON { (response) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            switch response.result {
            case .failure(let error):
                print(error)
            case .success:
                let decoder = JSONDecoder()
                
                if let result = response.data {
                    if movieType == .TopRated {
                        do {
                            let movies = try decoder.decode(Movies.self, from: result)
                            self.topRatedMovies = movies.results
                        }
                        catch {
                            print("Error: \(error)")
                        }
                    }
                    else {
                        do {
                            let movies = try decoder.decode(Movies.self, from: result)
                            self.popularMovies = movies.results
                        }
                        catch {
                            print("Error: \(error)")
                        }
                    }
                    
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

extension MoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movieType = type {
            return movieType == .TopRated ? topRatedMovies.count : popularMovies.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        var movie: Movie
        guard let movieType = type else { return UICollectionViewCell() }
        if movieType == .TopRated {
            movie = topRatedMovies[indexPath.row]
        }
        else {
            movie = popularMovies[indexPath.row]
        }
        cell.movieImage.kf.setImage(with: URL(string: Helper.imageURL + movie.posterPath))
        cell.movieTitle.text = movie.title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0,0,0,0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieDetailsVC = MovieDetailsViewController()
        guard let movieType = type else { return }
        if movieType == .TopRated {
            movieDetailsVC.movieID = topRatedMovies[indexPath.row].id
        }
        else {
            movieDetailsVC.movieID = popularMovies[indexPath.row].id
        }
        self.navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
}
