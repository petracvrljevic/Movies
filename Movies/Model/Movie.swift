//
//  Movie.swift
//  Movies
//
//  Created by Petra Cvrljevic on 22/08/2018.
//  Copyright © 2018 Petra Cvrljevic. All rights reserved.
//

import UIKit

struct Movie: Codable {
    let id: Int?
    let title: String
    let posterPath: String
    let genres: [Genres]?
    let backdropPath: String?
    let adult: Bool
    let overview: String
    let releaseDate: String
    
    enum CodingKeys : String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case genres 
        case backdropPath = "backdrop_path"
        case adult
        case overview
        case releaseDate = "release_date"
    }
}

struct Genres: Codable {
    let id: Int
    let name: String
}
