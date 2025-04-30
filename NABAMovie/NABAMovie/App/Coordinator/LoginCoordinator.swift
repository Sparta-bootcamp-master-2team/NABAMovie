//
//  LoginCoordinator.swift
//  NABAMovie
//
//  Created by 박주성 on 4/30/25.
//

import UIKit

final class LoginCoordinator: Coordinator {
    private let window: UIWindow
    private let diContainer: AppDIContainer
    private var parentCoordinator: AppCoordinator

    init(window: UIWindow, diContainer: AppDIContainer, parent: AppCoordinator) {
        self.window = window
        self.diContainer = diContainer
        self.parentCoordinator = parent
    }
    
    deinit {
        print("\(String(describing: Self.self)) 메모리 해제")
    }

    func start() {
        let loginVC = diContainer.makeLoginViewController(coordinator: self)
        window.rootViewController = loginVC
        window.makeKeyAndVisible()
    }

    func didLogin() {
        parentCoordinator.showTabBar()
    }
}
