//
//  FetchFavoriteMoviesUseCase.swift
//  NABAMovie
//
//  Created by 양원식 on 4/28/25.
//

import Foundation

// MARK: - FetchFavoriteMoviesUseCase
/// 사용자의 찜한 영화 목록을 가져오는 유스케이스
final class FetchFavoriteMoviesUseCase {
    
    // MARK: - Properties
    private let favoriteMovieRepository: FavoriteMovieRepository

    // MARK: - Initializer
    init(favoriteMovieRepository: FavoriteMovieRepository) {
        self.favoriteMovieRepository = favoriteMovieRepository
    }
    
    // MARK: - Execute
    /// 사용자 ID를 기반으로 찜한 영화 목록을 조회하는 메소드
    /// - Parameter userId: 사용자 고유 식별자 (UID)
    /// - Returns: 조회 결과 (Result<[MovieEntity], Error>)
    ///
    /// Usage Example:
    /// ```
    /// let result = await fetchFavoriteMoviesUseCase.execute(userId: "user-uid")
    /// switch result {
    /// case .success(let movies):
    ///     print(movies)
    /// case .failure(let error):
    ///     print(error.localizedDescription)
    /// }
    /// ```
    func execute(userId: String) async -> Result<[MovieEntity], Error> {
        do {
            let movies = try await favoriteMovieRepository.fetchFavoriteMovies(userID: userId)
            return .success(movies)
        } catch {
            return .failure(error)
        }
    }
}
