//
//  Helper.swift
//  Movies
//
//  Created by Petra Cvrljevic on 31/08/2018.
//  Copyright © 2018 Petra Cvrljevic. All rights reserved.
//

import UIKit
import Alamofire

class Helper: NSObject {
    static let apiKey = "fe3b8cf16d78a0e23f0c509d8c37caad"
    static let params: Parameters = ["api_key": apiKey]
    
    static let basicURL = "https://api.themoviedb.org/3"
    static let topRatedMoviesURL = URL(string: basicURL + "/movie/top_rated")!
    static let popularMoviesURL = URL(string: basicURL + "/movie/popular")!
    
    static let imageURL = "https://image.tmdb.org/t/p/w400/"
    
    static func movieDetailsURL(_ id: Int) -> URL {
        return URL(string: basicURL + "/movie/" + "\(id)")!
    }
    
    static func similarMoviesURL(_ id: Int) -> URL {
        return URL(string: basicURL + "/movie/" + "\(id)" + "/similar")!
    }
}
