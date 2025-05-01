//
//  UserRepository.swift
//  NABAMovie
//
//  Created by 양원식 on 5/1/25.
//

import Foundation

protocol UserRepository {
    /// 닉네임이 이미 존재하는지 확인
    func isNicknameTaken(_ nickname: String) async throws -> Bool

    /// 이메일이 이미 존재하는지 확인
    func isEmailTaken(_ email: String) async throws -> Bool
}
