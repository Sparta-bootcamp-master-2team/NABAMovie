//
//  AppFactory.swift
//  NABAMovie
//
//  Created by 박주성 on 4/30/25.
//

import UIKit

final class AppFactory {
    
    func makeLoginViewController(coordinator: LoginCoordinator) -> LoginViewController {
        let firebaseService = FirebaseService()
        let repository = FirebaseAuthRepositoryImpl(firebaseService: firebaseService)
        let useCase = LoginUseCase(repository: repository)
        let viewModel = LoginViewModel(loginUseCase: useCase)
        return LoginViewController(viewModel: viewModel, coordinator: coordinator)
    }
    
    func makeTabBarCoordinator(coordinator: AppCoordinator) -> TabBarCoordinator {
        let TabBarFactory = TabBarFactory()
        return TabBarCoordinator(TabBarFactory: TabBarFactory, parent: coordinator)
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
