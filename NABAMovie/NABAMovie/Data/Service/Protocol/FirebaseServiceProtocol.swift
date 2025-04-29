//
//  FirebaseServiceProtocol.swift
//  NABAMovie
//
//  Created by 양원식 on 4/28/25.
//
import Foundation

protocol FirebaseServiceProtocol {
    func signIn(email: String, password: String) async throws -> User
    func signUp(email: String, password: String, username: String) async throws -> User
    func signOut() throws
    func fetchUser(uid: String) async throws -> User
}
