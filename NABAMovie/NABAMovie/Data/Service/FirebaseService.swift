//
//  FirebaseService.swift
//  NABAMovie
//
//  Created by 양원식 on 4/28/25.
//

import FirebaseAuth
import FirebaseFirestore

// MARK: - FirebaseService
/// Firebase 인증(Authentication) 및 Firestore 데이터 작업을 처리하는 서비스 클래스
final class FirebaseService: FirebaseServiceProtocol {
    
    // MARK: - 로그인
    /// 이메일과 비밀번호로 사용자 로그인을 수행하는 메소드
    /// - Parameters:
    ///   - email: 사용자 이메일
    ///   - password: 사용자 비밀번호
    /// - Returns: 로그인한 사용자(User)
    /// - Throws: 로그인 실패 시 에러 발생
    ///
    /// Usage Example:
    /// ```
    /// let user = try await firebaseService.signIn(email: "test@example.com", password: "password123")
    /// print(user.username)
    /// ```
    func signIn(email: String, password: String) async throws -> User {
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return try await fetchUser(uid: authResult.user.uid)
    }
    
    // MARK: - 회원가입
    /// 이메일, 비밀번호, 닉네임으로 사용자 회원가입을 수행하는 메소드
    /// - Parameters:
    ///   - email: 사용자 이메일
    ///   - password: 사용자 비밀번호
    ///   - username: 사용자 닉네임
    /// - Returns: 생성된 사용자(User)
    /// - Throws: 회원가입 실패 시 에러 발생
    ///
    /// Usage Example:
    /// ```
    /// let user = try await firebaseService.signUp(email: "new@example.com", password: "password123", username: "newbie")
    /// print(user.username)
    /// ```
    func signUp(email: String, password: String, username: String) async throws -> User {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        let uid = authResult.user.uid
        try await Firestore.firestore().collection("users").document(uid).setData([
            "username": username
        ])
        return User(id: uid, username: username)
    }
    
    // MARK: - 로그아웃
    /// 현재 로그인된 사용자를 로그아웃하는 메소드
    /// - Throws: 로그아웃 실패 시 에러 발생
    ///
    /// Usage Example:
    /// ```
    /// try firebaseService.signOut()
    /// ```
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    // MARK: - 사용자 조회
    /// 사용자 ID(uid)를 기반으로 사용자 정보를 조회하는 메소드
    /// - Parameter uid: 사용자 고유 식별자 (UID)
    /// - Returns: 조회된 사용자(User)
    /// - Throws: 사용자 정보 조회 실패 시 에러 발생
    ///
    /// Usage Example:
    /// ```
    /// let user = try await firebaseService.fetchUser(uid: "some-uid")
    /// print(user.username)
    /// ```
    func fetchUser(uid: String) async throws -> User {
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        guard let data = snapshot.data(),
              let username = data["username"] as? String else {
            throw NSError(domain: "UserFetchError", code: 999, userInfo: [NSLocalizedDescriptionKey: "사용자 정보 없음"])
        }
        return User(id: uid, username: username)
    }
    
    // MARK: - 예약 목록 조회
    /// 사용자 ID를 기반으로 예약 내역을 조회하는 메소드
    /// - Parameter userId: 사용자 고유 식별자 (UID)
    /// - Returns: 예약 목록 ([ReservationDTO])
    /// - Throws: 조회 실패 시 에러 발생
    ///
    /// Usage Example:
    /// ```
    /// let reservations = try await firebaseService.fetchReservations(for: "user-uid")
    /// print(reservations.count)
    /// ```
    func fetchReservations(for userId: String) async throws -> [ReservationDTO] {
        let snapshot = try await Firestore.firestore()
            .collection("users")
            .document(userId)
            .collection("reservations")
            .getDocuments()
        
        let reservations: [ReservationDTO] = snapshot.documents.compactMap { document in
            try? document.data(as: ReservationDTO.self)
        }
        
        return reservations
    }
    
    // MARK: - 예약 추가
    /// 사용자 ID를 기반으로 예약 정보를 추가하는 메소드
    /// - Parameters:
    ///   - userId: 사용자 고유 식별자 (UID)
    ///   - reservation: 추가할 예약 정보 (ReservationDTO)
    /// - Throws: 추가 실패 시 에러 발생
    ///
    /// Usage Example:
    /// ```
    /// let newReservation = ReservationDTO(...)
    /// try await firebaseService.makeReservation(for: "user-uid", reservation: newReservation)
    /// ```
    func makeReservation(for userId: String, reservation: ReservationDTO) async throws {
        try await Firestore.firestore()
            .collection("users")
            .document(userId)
            .collection("reservations")
            .addDocument(data: [
                "genre": reservation.genre,
                "member": reservation.member,
                "posterURL": reservation.posterURL,
                "reservationTime": reservation.reservationTime,
                "title": reservation.title
            ])
    }
    
    // MARK: - 찜 목록 조회
    /// 사용자 ID를 기반으로 찜한 영화 목록을 조회하는 메소드
    /// - Parameter userId: 사용자 고유 식별자 (UID)
    /// - Returns: 찜한 영화 리스트 ([FavoriteMovieDTO])
    /// - Throws: 조회 실패 시 에러 발생
    ///
    /// Usage Example:
    /// ```
    /// let favorites = try await firebaseService.fetchFavoriteMovies(for: "user-uid")
    /// print(favorites.count)
    /// ```
    func fetchFavoriteMovies(for userId: String) async throws -> [FavoriteMovieDTO] {
        let snapshot = try await Firestore.firestore()
            .collection("users")
            .document(userId)
            .collection("favoriteMovies")
            .getDocuments()
        
        let favoriteMovies: [FavoriteMovieDTO] = snapshot.documents.compactMap { document in
            try? document.data(as: FavoriteMovieDTO.self)
        }
        
        return favoriteMovies
    }
    
    // MARK: - 찜 추가
    /// 사용자 ID를 기반으로 찜한 영화 정보를 추가하는 메소드
    /// - Parameters:
    ///   - userId: 사용자 고유 식별자 (UID)
    ///   - movie: 추가할 영화 정보 (FavoriteMovieDTO)
    /// - Throws: 추가 실패 시 에러 발생
    ///
    /// Usage Example:
    /// ```
    /// let favoriteMovie = FavoriteMovieDTO(...)
    /// try await firebaseService.addFavoriteMovie(userID: "user-uid", movie: favoriteMovie)
    /// ```
    func addFavoriteMovie(userID userId: String, movie: FavoriteMovieDTO) async throws {
        try await Firestore.firestore()
            .collection("users")
            .document(userId)
            .collection("favoriteMovies")
            .document(String(movie.movieID))
            .setData([
                "movieID": movie.movieID,
                "title": movie.title,
                "genre": movie.genre,
                "director": movie.director as Any,
                "actors": movie.actors,
                "releaseDate": movie.releaseDate as Any,
                "runtime": movie.runtime,
                "voteAverage": movie.voteAverage,
                "voteCount": movie.voteCount,
                "overview": movie.overview as Any,
                "posterImageURL": movie.posterImageURL as Any,
                "certification": movie.certification as Any
            ])
    }
    
    // MARK: - 현재 로그인된 사용자 ID 가져오기
    /// 현재 로그인한 사용자의 UID를 반환하는 메소드
    /// - Returns: 로그인된 사용자 UID (Optional String)
    ///
    /// Usage Example:
    /// ```
    //// let userId = try firebaseService.getCurrentUserId()
    // if let userId = userId {
    //     print("✅ 현재 로그인된 사용자 ID: \(userId)")
    // } else {
    //     print("❗ 로그인된 사용자가 없습니다.")
    // }
    /// ```
    func getCurrentUserId() throws -> String {
        if let uid = Auth.auth().currentUser?.uid {
            return uid
        } else {
            throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "로그인된 사용자가 없습니다."])
        }
    }

}
