//
//  FirebaseAuthRepositoryImpl.swift
//  NABAMovie
//
//  Created by 양원식 on 4/28/25.
//
import FirebaseAuth
import FirebaseFirestore

final class FirebaseAuthRepositoryImpl: AuthRepository {
    private let firebaseService: FirebaseServiceProtocol

    init(firebaseService: FirebaseServiceProtocol) {
        self.firebaseService = firebaseService
    }

    func login(email: String, password: String) async throws -> User {
        return try await firebaseService.signIn(email: email, password: password)
    }

    func logout() async throws {
        try firebaseService.signOut()
    }

    func register(email: String, password: String, username: String) async throws -> User {
        return try await firebaseService.signUp(email: email, password: password, username: username)
    }
}
