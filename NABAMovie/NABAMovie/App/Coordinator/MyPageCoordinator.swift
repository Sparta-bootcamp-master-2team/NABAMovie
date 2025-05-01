//
//  MyPageCoordinator.swift
//  NABAMovie
//
//  Created by 박주성 on 4/30/25.
//

import UIKit

final class MyPageCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let diContainer: MyPageDIContainer
    private let parentCoordinator: TabBarCoordinator

    init(
        navigationController: UINavigationController,
        diContainer: MyPageDIContainer,
        parent: TabBarCoordinator
    ) {
        self.navigationController = navigationController
        self.diContainer = diContainer
        self.parentCoordinator = parent
    }
    
    deinit {
        print("\(String(describing: Self.self)) 메모리 해제")
    }

    func start() {
        let viewController = diContainer.makeMyPageViewController()
        navigationController.setViewControllers([viewController], animated: false)
    }
}
