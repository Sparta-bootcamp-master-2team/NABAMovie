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

    init(navigationController: UINavigationController, diContainer: HomeDIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }

    func start() {
        let viewController = diContainer.makeHomeViewController()
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func showMovieInfo(movie: MovieEntity) {
        
    }
    
}
