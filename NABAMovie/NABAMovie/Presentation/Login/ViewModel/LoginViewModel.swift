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
    
    func login() async -> Result<User, Error> {
        do {
            let user = try await loginUseCase.execute(email: email, password: password)
            return .success(user)
        } catch {
            return .failure(error)
        }
    }
}
