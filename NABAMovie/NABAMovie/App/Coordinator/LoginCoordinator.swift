//
//  LoginCoordinator.swift
//  NABAMovie
//
//  Created by 박주성 on 4/30/25.
//

import UIKit

final class LoginCoordinator: Coordinator {
    private var parentCoordinator: AppCoordinator
    private let window: UIWindow
    private let diContainer: AppDIContainer

    init(window: UIWindow, diContainer: AppDIContainer, parent: AppCoordinator) {
        self.window = window
        self.diContainer = diContainer
        self.parentCoordinator = parent
    }
    
    deinit {
        print("로그인 코디네이터 메모리 해제")
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
