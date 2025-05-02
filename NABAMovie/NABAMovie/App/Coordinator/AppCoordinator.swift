//
//  AppCoordinator.swift
//  NABAMovie
//
//  Created by 박주성 on 4/30/25.
//

import UIKit
import FirebaseAuth

final class AppCoordinator {
    private let window: UIWindow
    private let factory: AppFactory
    private var currentCoordinators: [Coordinator] = []

    init(window: UIWindow, factory: AppFactory) {
        self.window = window
        self.factory = factory
    }
    
    deinit {
        print("\(String(describing: Self.self)) 메모리 해제")
    }

    func start() {
        isLoggedIn() ? showTabBar() : showLogin()
    }

    private func isLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }

    private func showLogin() {
        let loginCoordinator = LoginCoordinator(
            navigationController: UINavigationController(),
            factory: LoginFactory(),
            parent: self)
        
        currentCoordinators = [loginCoordinator]
        loginCoordinator.start()
        
        window.rootViewController = loginCoordinator.navigationController
        window.makeKeyAndVisible()
    }

    private func showTabBar() {
        let tabBarFactory = TabBarFactory()
        let tabBarCoordinator = TabBarCoordinator(factory: tabBarFactory, parent: self)

        currentCoordinators = [tabBarCoordinator]
        tabBarCoordinator.start()
        
        window.rootViewController = tabBarCoordinator.tabBarController
        window.makeKeyAndVisible()
    }
}
