//
//  LoginCoordinator.swift
//  NABAMovie
//
//  Created by 박주성 on 4/30/25.
//

import UIKit

protocol LoginCoordinatorProtocol: Coordinator {
    func showSignup()
    func didLogin()
    func showCompletedSignUp(name: String)
    func backButtonDidtap()
}

final class LoginCoordinator: LoginCoordinatorProtocol {
    
    let navigationController: UINavigationController
    private let factory: LoginFactory
    private(set) weak var parentCoordinator: AppCoordinator?

    init(
         navigationController: UINavigationController,
         factory: LoginFactory,
         parent: AppCoordinator
    ) {
        self.navigationController = navigationController
        self.factory = factory
        self.parentCoordinator = parent
    }
    
    deinit {
        print("\(String(describing: Self.self)) 메모리 해제")
    }

    func start() {
        let loginVC = factory.makeLoginViewController(coordinator: self)
        navigationController.setViewControllers([loginVC], animated: true)
    }
    
    func showSignup() {
        let signUpVC = factory.makeSignupViewController(coordinator: self)
        self.navigationController.pushViewController(signUpVC, animated: true)
    }

    func didLogin() {
        parentCoordinator?.start()
    }
    
    func showCompletedSignUp(name: String) {
        let vc = CompletedSignUpViewController(username: name, coordinator: self)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func backButtonDidtap() {
        self.navigationController.popViewController(animated: true)
    }
}
