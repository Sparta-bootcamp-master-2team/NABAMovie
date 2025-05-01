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
    private let diContainer: HomeFactory
    private let parentCoordinator: TabBarCoordinator
    private var currentCoordinators: [Coordinator] = []

    init(
        navigationController: UINavigationController,
        diContainer: HomeFactory,
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
        let movieInfoCoordinator = MovieInfoCoordinator(
            navigationController: self.navigationController,
            diContainer: MovieInfoFactory(),
            parentCoordinator: self,
            movie: movie
        )
        
        currentCoordinators = [movieInfoCoordinator]
        movieInfoCoordinator.start()
    }
}
