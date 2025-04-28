//
//  FavoriteMovies.swift
//  NABAMovie
//
//  Created by 양원식 on 4/28/25.
//

import Foundation

struct FavoriteMovie {
    let id: String
    let title: String
    let director: String
    let genres: [String]
    let overview: String
    let posterImageURL: String
    let releaseDate: String
    let runtime: Int
    let voteAverage: Double
    let voteCount: Int
}
