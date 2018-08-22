//
//  MovieDetailsViewController.swift
//  Movies
//
//  Created by Petra Cvrljevic on 22/08/2018.
//  Copyright © 2018 Petra Cvrljevic. All rights reserved.
//

import UIKit
import TagListView
import Alamofire
import SwiftyJSON
import Kingfisher

class MovieDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var helpView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var overviewTextView: UITextView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movieID: Int?
    var similarMovies = [Movie]()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "SimilarMovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "similarMovieCell")
        
        helpView.layer.cornerRadius = 5
        
        if let movieID = movieID {
            downloadMovieDetails(movieID)
        }
        downloadSimilarMovies()
    }

    func downloadMovieDetails(_ id: Int) {
        Alamofire.request(Datasource.movieDetailsURL(id), method: .get, parameters: Datasource.params).responseJSON { (response) in
            
            if response.result.isSuccess {
                var results = JSON(response.result.value!)

                let data = try? JSONSerialization.data(withJSONObject: results.object, options: .prettyPrinted)

                let decoder = JSONDecoder()
                let movie = try! decoder.decode(Movie.self, from: data!)
                
                self.posterImage.kf.setImage(with: URL(string: Datasource.imageURL + movie.posterPath))
                self.titleLabel.text = movie.title
                self.releaseLabel.text = movie.releaseDate
                self.coverImage.kf.setImage(with: URL(string: Datasource.imageURL + movie.backdropPath!))
                self.overviewTextView.text = movie.overview
                
                var movieGenres = [String]()
                if let genres = movie.genres {
                    for genre in genres {
                        movieGenres.append(genre.name)
                    }
                }
                self.tagListView.removeAllTags()
                self.tagListView.addTags(movieGenres)
            }
        }
    }
    
    func downloadSimilarMovies() {
        guard let movieID = movieID else { return }
        Alamofire.request(Datasource.similarMoviesURL(movieID), method: .get, parameters: Datasource.params).responseJSON { (response) in
            
            if response.result.isSuccess {
                var results = JSON(response.result.value!)
                results = results["results"]
                
                let data = try? JSONSerialization.data(withJSONObject: results.object, options: .prettyPrinted)
                
                let decoder = JSONDecoder()
                self.similarMovies = try! decoder.decode([Movie].self, from: data!)
                self.collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "similarMovieCell", for: indexPath) as! SimilarMovieCollectionViewCell
        let similarMovie = similarMovies[indexPath.row]
        cell.movieImage.kf.setImage(with: URL(string: Datasource.imageURL + similarMovie.posterPath), placeholder: UIImage(named: "defaultImage"), options: nil, progressBlock: nil, completionHandler: nil)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movieID = similarMovies[indexPath.row].id {
            downloadMovieDetails(movieID)
        }
    }
}
