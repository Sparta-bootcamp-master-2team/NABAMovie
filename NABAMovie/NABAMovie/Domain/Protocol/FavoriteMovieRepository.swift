//
//  FavoriteMovieRepository.swift
//  NABAMovie
//
//  Created by 양원식 on 4/28/25.
//

import Foundation
import UIKit

// MARK: - FavoriteMovieRepository
/// 찜한 영화(Favorite Movie) 데이터를 관리하는 Repository 프로토콜
protocol FavoriteMovieRepository {
    
    // MARK: - 찜 목록 조회
    /// 사용자의 찜한 영화 목록을 조회하는 메소드
    /// - Parameter userID: 사용자 고유 식별자 (UID)
    /// - Returns: 찜한 영화 리스트 ([MovieEntity])
    func fetchFavoriteMovies(userID: String) async throws -> [MovieEntity]
    
    // MARK: - 찜 추가
    /// 사용자의 찜한 영화 목록에 영화를 추가하는 메소드
    /// - Parameters:
    ///   - userID: 사용자 고유 식별자 (UID)
    ///   - movie: 추가할 영화 정보 (MovieEntity)
    func addFavoriteMovie(userID: String, movie: MovieEntity) async throws
    
    // MARK: - 찜 삭제 (개별)
    /// 찜한 영화 한 편을 삭제하는 메소드
    /// - Parameters:
    ///   - userID: 사용자 고유 식별자 (UID)
    ///   - movieID: 삭제할 영화 ID
    func removeFavoriteMovie(userID: String, movieID: Int) async throws
    
    // MARK: - 찜 삭제 (전체)
    /// 사용자의 찜한 영화 목록 전체를 삭제하는 메소드
    /// - Parameter userID: 사용자 고유 식별자 (UID)
    func removeAllFavoriteMovies(userID: String) async throws
}
