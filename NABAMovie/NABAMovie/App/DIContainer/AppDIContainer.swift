//
//  AppDIContainer.swift
//  NABAMovie
//
//  Created by 박주성 on 4/30/25.
//

import UIKit

final class AppDIContainer {
    
    func makeLoginViewController(coordinator: LoginCoordinator) -> LoginViewController {
        let firebaseService = FirebaseService()
        let repository = FirebaseAuthRepositoryImpl(firebaseService: firebaseService)
        let useCase = LoginUseCase(repository: repository)
        let viewModel = LoginViewModel(loginUseCase: useCase)
        return LoginViewController(viewModel: viewModel, coordinator: coordinator)
    }
    
    func makeTabBarCoordinator() -> TabBarCoordinator {
        let tabBarDIContainer = TabBarDIContainer()
        return TabBarCoordinator(tabBarDIContainer: tabBarDIContainer)
    }
}
