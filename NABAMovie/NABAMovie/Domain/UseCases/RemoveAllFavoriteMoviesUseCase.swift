//
//  RemoveAllFavoriteMoviesUseCase.swift
//  NABAMovie
//
//  Created by 양원식 on 4/30/25.
//


final class RemoveAllFavoriteMoviesUseCase {
    private let repository: FavoriteMovieRepository

    init(repository: FavoriteMovieRepository) {
        self.repository = repository
    }

    /// 찜한 영화 전체 삭제
    /// - Parameter userID: 사용자 UID
    func execute(userID: String) async -> Result<Void, Error> {
        do {
            try await repository.removeAllFavoriteMovies(userID: userID)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
