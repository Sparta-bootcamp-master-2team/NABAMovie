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

    init(navigationController: UINavigationController, diContainer: MyPageDIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }
    
    deinit {
        print("\(String(describing: Self.self)) 메모리 해제")
    }

    func start() {
        let viewController = diContainer.makeMyPageViewController()
        navigationController.setViewControllers([viewController], animated: false)
    }
}
