//
//  AddFavoriteMovieUseCase.swift
//  NABAMovie
//
//  Created by 양원식 on 4/28/25.
//

import Foundation

// MARK: - AddFavoriteMovieUseCase
/// 사용자의 찜 목록에 영화를 추가하는 유스케이스
final class AddFavoriteMovieUseCase {
    
    // MARK: - Properties
    private let repository: FavoriteMovieRepository

    // MARK: - Initializer
    init(repository: FavoriteMovieRepository) {
        self.repository = repository
    }

    // MARK: - Execute
    /// 사용자 ID와 영화 정보를 받아 찜 목록에 추가하는 메소드
    /// - Parameters:
    ///   - userId: 사용자 고유 식별자 (UID)
    ///   - movie: 추가할 영화 정보 (MovieEntity)
    /// - Returns: 추가 결과 (Result<Void, Error>)
    ///
    /// Usage Example:
    /// ```
    /// let movie = MovieEntity(...)
    /// let result = await addFavoriteMovieUseCase.execute(userId: "user-uid", movie: movie)
    /// switch result {
    /// case .success:
    ///     print("찜 추가 성공")
    /// case .failure(let error):
    ///     print(error.localizedDescription)
    /// }
    /// ```
    func execute(userId: String, movie: MovieEntity) async -> Result<Void, Error> {
        do {
            try await repository.addFavoriteMovie(userID: userId, movie: movie)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}

