//
//  RemoveFavoriteMovieUseCase.swift
//  NABAMovie
//
//  Created by 양원식 on 4/30/25.
//

final class RemoveFavoriteMovieUseCase {
    private let repository: FavoriteMovieRepository

    init(repository: FavoriteMovieRepository) {
        self.repository = repository
    }

    /// 찜한 영화 한 편을 삭제
    /// - Parameters:
    ///   - userID: 사용자 UID
    ///   - movieID: 삭제할 영화 ID
    func execute(userID: String, movieID: Int) async -> Result<Void, Error> {
        do {
            try await repository.removeFavoriteMovie(userID: userID, movieID: movieID)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
