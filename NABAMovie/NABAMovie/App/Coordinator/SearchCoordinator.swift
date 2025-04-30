//
//  SearchCoordinator.swift
//  NABAMovie
//
//  Created by 박주성 on 4/30/25.
//

import UIKit

final class SearchCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let diContainer: SearchDIContainer

    init(navigationController: UINavigationController, diContainer: SearchDIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }

    func start() {
        let viewController = diContainer.makeSearchViewController()
        navigationController.setViewControllers([viewController], animated: false)
    }
}
