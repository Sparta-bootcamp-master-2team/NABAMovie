//
//  HomeCoordinator.swift
//  NABAMovie
//
//  Created by 박주성 on 4/30/25.
//

import UIKit

protocol HomeCoordinatorProtocol: Coordinator {
    func showMovieInfo(movie: MovieEntity)
}

final class HomeCoordinator: HomeCoordinatorProtocol {
    private let navigationController: UINavigationController
    private let diContainer: HomeDIContainer
    private let parentCoordinator: TabBarCoordinator
    private let childCoordinators: [Coordinator] = []

    init(
        navigationController: UINavigationController,
        diContainer: HomeDIContainer,
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
        let vc = diContainer.makeHomeViewController(coordinator: self)
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func showMovieInfo(movie: MovieEntity) {
        let vc = diContainer.makeMovieInfoController(movie: movie)
        navigationController.pushViewController(vc, animated: true)
    }
    
}
