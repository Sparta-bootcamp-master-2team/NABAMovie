//
//  FirebaseAuthRepositoryImpl.swift
//  NABAMovie
//
//  Created by 양원식 on 4/28/25.
//

import FirebaseAuth
import FirebaseFirestore

// MARK: - FirebaseAuthRepositoryImpl
/// 사용자 인증(Authentication) 기능을 FirebaseService를 통해 구현한 Repository 클래스
final class FirebaseAuthRepositoryImpl: AuthRepository {
    
    // MARK: - Properties
    private let firebaseService: FirebaseServiceProtocol

    // MARK: - Initializer
    init(firebaseService: FirebaseServiceProtocol) {
        self.firebaseService = firebaseService
    }

    // MARK: - 로그인
    /// 이메일과 비밀번호로 로그인하는 메소드
    /// - Parameters:
    ///   - email: 사용자 이메일
    ///   - password: 사용자 비밀번호
    /// - Returns: 로그인한 사용자 정보 (User)
    func login(email: String, password: String) async throws -> User {
        return try await firebaseService.signIn(email: email, password: password)
    }

    // MARK: - 로그아웃
    /// 현재 로그인된 사용자를 로그아웃하는 메소드
    func logout() async throws {
        try firebaseService.signOut()
    }

    // MARK: - 회원가입
    /// 이메일, 비밀번호, 닉네임으로 회원가입하는 메소드
    /// - Parameters:
    ///   - email: 사용자 이메일
    ///   - password: 사용자 비밀번호
    ///   - username: 사용자 닉네임
    /// - Returns: 새로 등록된 사용자 정보 (User)
    func register(email: String, password: String, username: String) async throws -> User {
        return try await firebaseService.signUp(email: email, password: password, username: username)
    }
}

