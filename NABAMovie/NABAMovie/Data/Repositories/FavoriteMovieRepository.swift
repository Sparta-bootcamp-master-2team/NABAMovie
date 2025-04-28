//
//  FavoriteMovieRepository.swift
//  NABAMovie
//
//  Created by 양원식 on 4/28/25.
//

import Foundation
import UIKit

protocol FavoriteMovieRepository {
    func fetchFavoriteMovies(userID: String) async throws -> [FavoriteMovie]
    func addFavoriteMovie(userID: String, movie: FavoriteMovie) async throws
}
