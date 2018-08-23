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
    @IBOutlet weak var tabBar: UITabBar!
    
    var topRatedMovies = [Movie]()
    var popularMovies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "movieCell")
        
        tabBar.selectedItem = tabBar.items?[0]
        getTopRatedMovies()
        getPopularMovies()
    }
    
    func getTopRatedMovies() {
        getMovies(Datasource.topRatedMoviesURL!, .TopRated)
    }
    
    func getPopularMovies() {
        getMovies(Datasource.popularMoviesURL!, .Popular)
    }
    
    func getMovies(_ url: URL, _ movieType: MovieType) {
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        loadingNotification.isUserInteractionEnabled = false
        
        Alamofire.request(url, method: .get, parameters: Datasource.params).responseJSON { (response) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if response.result.isSuccess {
                var results = JSON(response.result.value!)
                results = results["results"]
                
                let data = try? JSONSerialization.data(withJSONObject: results.object, options: .prettyPrinted)
                
                let decoder = JSONDecoder()
                
                if let data = data {
                    if movieType == .TopRated {
                        do {
                            self.topRatedMovies = try decoder.decode([Movie].self, from: data)
                        }
                        catch {
                            print("Error: \(error)")
                        }
                    }
                    else {
                        do {
                            self.popularMovies = try decoder.decode([Movie].self, from: data)
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
    
    enum MovieType {
        case TopRated
        case Popular
    }

}

extension MoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabBar.tag == 0 ? topRatedMovies.count : popularMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        var movie: Movie
        if tabBar.selectedItem == tabBar.items![0] {
            movie = topRatedMovies[indexPath.row]
        }
        else {
            movie = popularMovies[indexPath.row]
        }
        cell.movieImage.kf.setImage(with: URL(string: Datasource.imageURL + movie.posterPath))
        cell.movieTitle.text = movie.title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2, height: 200)
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
        if tabBar.selectedItem == tabBar.items![0] {
            movieDetailsVC.movieID = topRatedMovies[indexPath.row].id
        }
        else {
            movieDetailsVC.movieID = popularMovies[indexPath.row].id
        }
        self.navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
}

extension MoviesViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == tabBar.items![0] {
            self.navigationItem.title = "Top rated movies"
        }
        else {
            self.navigationItem.title = "Popular movies"
        }
        collectionView.reloadData()
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredVertically, animated: true)
    }
}
