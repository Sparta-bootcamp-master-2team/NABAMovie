//
//  FavoriteMovieRepositoryImpl.swift
//  NABAMovie
//
//  Created by 양원식 on 4/29/25.
//

import Foundation

final class FavoriteMovieRepositoryImpl: FavoriteMovieRepository {
    private let firebaseService: FirebaseServiceProtocol

    init(firebaseService: FirebaseServiceProtocol) {
        self.firebaseService = firebaseService
    }

    func fetchFavoriteMovies(for userId: String) async throws -> [MovieEntity] {
        let dtos = try await firebaseService.fetchFavoriteMovies(for: userId)
        return dtos.map { $0.toEntity() }
    }
}
