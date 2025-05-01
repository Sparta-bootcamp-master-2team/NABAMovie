//
//  SearchCoordinator.swift
//  NABAMovie
//
//  Created by 박주성 on 4/30/25.
//

import UIKit

protocol SearchCoordinatorProtocol: Coordinator {
    func showMovieInfo(movie: MovieEntity)
}

final class SearchCoordinator: SearchCoordinatorProtocol {
    private let navigationController: UINavigationController
    private let diContainer: SearchFactory
    private let parentCoordinator: TabBarCoordinator
    private var currentCoordinators: [Coordinator] = []

    init(
        navigationController: UINavigationController,
        diContainer: SearchFactory,
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
        let viewController = diContainer.makeMovieSearchViewController(coordinator: self)
        navigationController.setViewControllers([viewController], animated: false)
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
