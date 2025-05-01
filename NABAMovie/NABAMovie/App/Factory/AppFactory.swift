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
        let tabBarFactory = TabBarFactory()
        return TabBarCoordinator(factory: tabBarFactory, parent: coordinator)
    }
}
