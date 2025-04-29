//
//  LoginViewModel.swift
//  NABAMovie
//
//  Created by 양원식 on 4/28/25.
//

import Foundation

final class LoginViewModel {
    private let loginUseCase: LoginUseCase

    var email: String = ""
    var password: String = ""

    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }

    func login(completion: @escaping (Result<User, Error>) -> Void) {
        Task {
            do {
                let user = try await loginUseCase.execute(email: email, password: password)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
