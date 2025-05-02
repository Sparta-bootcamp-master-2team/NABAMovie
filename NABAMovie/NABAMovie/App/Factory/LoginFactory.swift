//
//  LoginFactory.swift
//  NABAMovie
//
//  Created by 박주성 on 5/1/25.
//

import UIKit

final class LoginFactory {
    
    func makeLoginViewController(coordinator: LoginCoordinator) -> LoginViewController {
        let firebaseService = FirebaseService()
        let repository = FirebaseAuthRepositoryImpl(firebaseService: firebaseService)
        let useCase = LoginUseCase(repository: repository)
        let viewModel = LoginViewModel(loginUseCase: useCase)
        return LoginViewController(viewModel: viewModel, coordinator: coordinator)
    }
    
    func makeSignupViewController(coordinator: LoginCoordinator) -> SignupViewController {
        let firebaseService = FirebaseService()
        
        let authRepository = FirebaseAuthRepositoryImpl(firebaseService: firebaseService)
        let userRepository = FirebaseUserRepositoryImpl(firebaseService: firebaseService)
        let registerUseCase = RegisterUseCase(repository: authRepository)
        let loginUseCase = LoginUseCase(repository: authRepository)

        let signupViewModel = SignupViewModel(
            registerUseCase: registerUseCase,
            loginUseCase: loginUseCase,
            userRepository: userRepository
        )
        
        return SignupViewController(viewModel: signupViewModel, coordinator: coordinator)
    }
}
