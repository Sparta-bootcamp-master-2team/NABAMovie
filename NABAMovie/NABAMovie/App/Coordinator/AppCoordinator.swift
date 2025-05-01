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
    private let diContainer: AppDIContainer
    private var tabBarCoordinator: TabBarCoordinator?
    private var childCoordinators: [Coordinator] = []

    init(window: UIWindow, diContainer: AppDIContainer) {
        self.window = window
        self.diContainer = diContainer
    }
    
    deinit {
        print("\(String(describing: Self.self)) 메모리 해제")
    }

    func start() {
        if isLoggedIn() {
            showTabBar()
        } else {
            showLogin()
        }
    }

    private func isLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }

    func showLogin() {
        let loginCoordinator = LoginCoordinator(
            window: window,
            navigationController: UINavigationController(),
            diContainer: diContainer,
            parent: self)
        childCoordinators.append(loginCoordinator)
        loginCoordinator.start()
    }

    func showTabBar() {
        let tabBarDI = TabBarDIContainer()
        let tabBarCoordinator = TabBarCoordinator(tabBarDIContainer: tabBarDI)
        self.tabBarCoordinator = tabBarCoordinator

        tabBarCoordinator.start()
        window.rootViewController = tabBarCoordinator.tabBarController
        window.makeKeyAndVisible()
    }
}
