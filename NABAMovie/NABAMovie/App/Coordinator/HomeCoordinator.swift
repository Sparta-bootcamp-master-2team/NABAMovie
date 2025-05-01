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
    private let factory: HomeFactory
    private(set) weak var parentCoordinator: TabBarCoordinator?
    private var currentCoordinators: [Coordinator] = []

    init(
        navigationController: UINavigationController,
        factory: HomeFactory,
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
        let vc = factory.makeHomeViewController(coordinator: self)
        navigationController.setViewControllers([vc], animated: false)
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
