//
//  FirebaseUserRepositoryImpl.swift
//  NABAMovie
//
//  Created by 양원식 on 5/1/25.
//

import Foundation

final class FirebaseUserRepositoryImpl: UserRepository {

    private let firebaseService: FirebaseServiceProtocol

    init(firebaseService: FirebaseServiceProtocol) {
        self.firebaseService = firebaseService
    }

    func isNicknameTaken(_ nickname: String) async throws -> Bool {
        return try await firebaseService.isNicknameTaken(nickname)
    }

    func isEmailTaken(_ email: String) async throws -> Bool {
        return try await firebaseService.isEmailTaken(email)
    }
}
