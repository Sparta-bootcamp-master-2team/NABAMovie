//
//  AuthRepository.swift
//  NABAMovie
//
//  Created by 양원식 on 4/28/25.
//

import Foundation
import UIKit

// MARK: - AuthRepository
/// 사용자 인증(Authentication) 관련 기능을 추상화한 Repository 프로토콜
protocol AuthRepository {
    
    // MARK: - 로그인
    /// 이메일과 비밀번호를 사용하여 로그인하는 메소드
    /// - Parameters:
    ///   - email: 사용자 이메일
    ///   - password: 사용자 비밀번호
    /// - Returns: 로그인한 사용자(User)
    func login(email: String, password: String) async throws -> User

    // MARK: - 로그아웃
    /// 현재 로그인된 사용자를 로그아웃하는 메소드
    func logout() async throws

    // MARK: - 회원가입
    /// 이메일, 비밀번호, 사용자 이름을 사용하여 회원가입하는 메소드
    /// - Parameters:
    ///   - email: 사용자 이메일
    ///   - password: 사용자 비밀번호
    ///   - username: 사용자 닉네임
    /// - Returns: 새로 등록된 사용자(User)
    func register(email: String, password: String, username: String) async throws -> User
}
