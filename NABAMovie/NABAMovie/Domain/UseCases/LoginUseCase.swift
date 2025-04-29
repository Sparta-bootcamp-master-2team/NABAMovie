//
//  LoginUseCase.swift
//  NABAMovie
//
//  Created by 양원식 on 4/28/25.
//

import Foundation

// MARK: - LoginUseCase
/// 이메일과 비밀번호를 사용하여 로그인을 수행하는 유스케이스
final class LoginUseCase {
    
    // MARK: - Properties
    private let repository: AuthRepository

    // MARK: - Initializer
    init(repository: AuthRepository) {
        self.repository = repository
    }

    // MARK: - Execute
    /// 로그인 실행 메소드
    /// - Parameters:
    ///   - email: 사용자 이메일
    ///   - password: 사용자 비밀번호
    /// - Returns: 로그인한 사용자(User)
    /// - Throws: 로그인 실패 시 에러 발생
    ///
    /// Usage Example:
    /// ```
    /// let user = try await loginUseCase.execute(email: "test@example.com", password: "password123")
    /// print(user.username)
    /// ```
    func execute(email: String, password: String) async throws -> User {
        return try await repository.login(email: email, password: password)
    }
}

