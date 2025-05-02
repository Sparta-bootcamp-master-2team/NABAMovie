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
    private let factory: SearchFactory
    private(set) weak var parentCoordinator: TabBarCoordinator?
    private var currentCoordinators: [Coordinator] = []

    init(
        navigationController: UINavigationController,
        factory: SearchFactory,
        parent: TabBarCoordinator
    ) {
        self.navigationController = navigationController
        self.factory = factory
        self.parentCoordinator = parent
    }
    
    deinit {
        print("\(String(describing: Self.self)) 메모리 해제")
    }

    func start() {
        let viewController = factory.makeMovieSearchViewController(coordinator: self)
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func showMovieInfo(movie: MovieEntity) {
        let movieInfoCoordinator = MovieInfoCoordinator(
            movie: movie,
            navigationController: self.navigationController,
            factory: MovieInfoFactory(),
            parentCoordinator: self
        )
        
        currentCoordinators = [movieInfoCoordinator]
        movieInfoCoordinator.start()
    }
}
