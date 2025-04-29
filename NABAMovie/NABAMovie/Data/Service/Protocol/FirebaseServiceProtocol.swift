//
//  FirebaseServiceProtocol.swift
//  NABAMovie
//
//  Created by 양원식 on 4/28/25.
//
import Foundation

// MARK: - FirebaseServiceProtocol
/// Firebase 관련 인증(Authentication) 및 데이터(Firestore) 기능을 정의한 서비스 프로토콜
protocol FirebaseServiceProtocol {
    
    // MARK: - 인증(Authentication)
    
    /// 이메일과 비밀번호로 로그인하는 메소드
    /// - Parameters:
    ///   - email: 사용자 이메일
    ///   - password: 사용자 비밀번호
    /// - Returns: 로그인한 사용자(User)
    func signIn(email: String, password: String) async throws -> User
    
    /// 이메일, 비밀번호, 닉네임으로 회원가입하는 메소드
    /// - Parameters:
    ///   - email: 사용자 이메일
    ///   - password: 사용자 비밀번호
    ///   - username: 사용자 닉네임
    /// - Returns: 새로 등록된 사용자(User)
    func signUp(email: String, password: String, username: String) async throws -> User
    
    /// 현재 로그인된 사용자를 로그아웃하는 메소드
    func signOut() throws
    
    /// 사용자 ID로 사용자 정보를 조회하는 메소드
    /// - Parameter uid: 사용자 고유 식별자 (UID)
    /// - Returns: 사용자(User)
    func fetchUser(uid: String) async throws -> User
    
    // MARK: - 예약(Reservation)
    
    /// 사용자 ID로 예약 목록을 조회하는 메소드
    /// - Parameter userId: 사용자 고유 식별자 (UID)
    /// - Returns: 예약 리스트 ([ReservationDTO])
    func fetchReservations(for userId: String) async throws -> [ReservationDTO]
    
    /// 사용자 ID로 새로운 예약을 추가하는 메소드
    /// - Parameters:
    ///   - userId: 사용자 고유 식별자 (UID)
    ///   - reservation: 추가할 예약 정보 (ReservationDTO)
    func makeReservation(for userId: String, reservation: ReservationDTO) async throws
    
    // MARK: - 찜(Favorite Movies)
    
    /// 사용자 ID로 찜한 영화 목록을 조회하는 메소드
    /// - Parameter userId: 사용자 고유 식별자 (UID)
    /// - Returns: 찜한 영화 리스트 ([FavoriteMovieDTO])
    func fetchFavoriteMovies(for userId: String) async throws -> [FavoriteMovieDTO]
    
    /// 사용자 ID로 새로운 찜한 영화를 추가하는 메소드
    /// - Parameters:
    ///   - userID: 사용자 고유 식별자 (UID)
    ///   - movie: 추가할 영화 정보 (FavoriteMovieDTO)
    func addFavoriteMovie(userID: String, movie: FavoriteMovieDTO) async throws
}

