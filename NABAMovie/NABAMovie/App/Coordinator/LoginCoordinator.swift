//
//  LoginCoordinator.swift
//  NABAMovie
//
//  Created by 박주성 on 4/30/25.
//

import UIKit

final class LoginCoordinator: Coordinator {
    private let window: UIWindow
    private let navigationController: UINavigationController
    private let diContainer: AppDIContainer
    private var parentCoordinator: AppCoordinator

    init(window: UIWindow,
         navigationController: UINavigationController,
         diContainer: AppDIContainer,
         parent: AppCoordinator
    ) {
        self.window = window
        self.navigationController = navigationController
        self.diContainer = diContainer
        self.parentCoordinator = parent
    }
    
    deinit {
        print("\(String(describing: Self.self)) 메모리 해제")
    }

    func start() {
        let loginVC = diContainer.makeLoginViewController(coordinator: self)
        navigationController.setViewControllers([loginVC], animated: true)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func showSignUp() {
        let signUpVC = diContainer.makeSignupViewController(coordinator: self)
        self.navigationController.pushViewController(signUpVC, animated: true)
    }

    func didLogin() {
        parentCoordinator.showTabBar()
    }
}
