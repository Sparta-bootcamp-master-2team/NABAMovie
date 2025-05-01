//
//  LogoutUseCase.swift
//  NABAMovie
//
//  Created by 양원식 on 4/28/25.
//
import Foundation

final class LogoutUseCase {
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func execute() async -> Bool {
        do {
            try await repository.logout()
            return true
        } catch {
            return false
        }
    }
}
