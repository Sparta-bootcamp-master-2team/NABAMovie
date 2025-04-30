//
//  FavoriteMovieRepositoryImpl.swift
//  NABAMovie
//
//  Created by 양원식 on 4/29/25.
//

import Foundation

// MARK: - FavoriteMovieRepositoryImpl
/// 찜한 영화(Favorite Movie) 관련 기능을 실제로 구현한 Repository 클래스
final class FavoriteMovieRepositoryImpl: FavoriteMovieRepository {
    
    // MARK: - Properties
    private let firebaseService: FirebaseServiceProtocol
    
    // MARK: - Initializer
    init(firebaseService: FirebaseServiceProtocol) {
        self.firebaseService = firebaseService
    }
    
    // MARK: - 찜 목록 조회
    /// 사용자 ID를 이용해 찜한 영화 목록을 조회하는 메소드
    /// - Parameter userId: 사용자 고유 식별자 (UID)
    /// - Returns: 찜한 영화 리스트 ([MovieEntity])
    func fetchFavoriteMovies(userID userId: String) async throws -> [MovieEntity] {
        let dtos = try await firebaseService.fetchFavoriteMovies(for: userId)
        return dtos.map { $0.toEntity() }
    }
    
    // MARK: - 찜 추가
    /// 사용자 ID를 이용해 새로운 찜 영화를 추가하는 메소드
    /// - Parameters:
    ///   - userID: 사용자 고유 식별자 (UID)
    ///   - movie: 추가할 영화 정보 (MovieEntity)
    func addFavoriteMovie(userID: String, movie: MovieEntity) async throws {
        let dto = FavoriteMovieDTO(entity: movie)
        try await firebaseService.addFavoriteMovie(for: userID, movie: dto)
    }
    
    func removeFavoriteMovie(userID: String, movieID: Int) async throws {
        try await firebaseService.removeFavoriteMovie(for: userID, movieID: movieID)
    }
    
    func removeAllFavoriteMovies(userID: String) async throws {
        try await firebaseService.removeAllFavoriteMovies(for: userID)
    }
}

