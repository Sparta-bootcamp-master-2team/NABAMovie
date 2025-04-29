//
//  AddFavoriteMovieUseCase.swift
//  NABAMovie
//
//  Created by 양원식 on 4/28/25.
//

final class AddFavoriteMovieUseCase {
    private let repository: FavoriteMovieRepository

    init(repository: FavoriteMovieRepository) {
        self.repository = repository
    }

    func execute(userId: String, movie: MovieEntity) async -> Result<Void, Error> {
        do {
            try await repository.addFavoriteMovie(userID: userId, movie: movie)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
