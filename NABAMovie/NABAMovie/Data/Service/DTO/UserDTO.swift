//
//  UserDTO.swift
//  NABAMovie
//
//  Created by 양원식 on 4/28/25.
//

import Foundation

// MARK: - UserDTO
/// Firestore에 저장하거나 가져오는 사용자 데이터 모델 (DTO)
struct UserDTO: Codable {
    let id: String               // 사용자 고유 식별자 (UID)
    let username: String         // 사용자 닉네임

    // MARK: - Domain 변환
    /// DTO를 앱 내부 모델(User)로 변환하는 메소드
    func toDomain() -> User {
        return User(id: id, username: username)
    }
}
