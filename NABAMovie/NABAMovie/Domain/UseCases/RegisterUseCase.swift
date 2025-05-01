//
//  RegisterUseCase.swift
//  NABAMovie
//
//  Created by 양원식 on 4/28/25.
//
import Foundation

final class RegisterUseCase {
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func execute(email: String, password: String, username: String) async -> Result<User, Error> {
        do {
            let user = try await repository.register(email: email, password: password, username: username)
            return .success(user)
        } catch {
            return .failure(error)
        }
    }
}
