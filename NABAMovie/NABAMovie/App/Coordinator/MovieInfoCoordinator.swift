//
//  MovieInfoCoordinator.swift
//  NABAMovie
//
//  Created by 박주성 on 5/1/25.
//

import UIKit

protocol MovieInfoCoordinatorProtocol: Coordinator {
    
}

final class MovieInfoCoordinator: MovieInfoCoordinatorProtocol {
    let navigationController: UINavigationController
    private let diContainer: MovieInfoFactory
    private var parentCoordinator: Coordinator
    private let movie: MovieEntity
    
    init(navigationController: UINavigationController,
         diContainer: MovieInfoFactory,
         parentCoordinator: Coordinator,
         movie: MovieEntity
    ) {
        self.navigationController = navigationController
        self.diContainer = diContainer
        self.parentCoordinator = parentCoordinator
        self.movie = movie
    }
    
    deinit {
        print("\(String(describing: Self.self)) 메모리 해제")
    }

    func start() {
        let vc = diContainer.makeMovieInfoViewController(
            movie: self.movie,
            coordinator: self
        )
        navigationController.pushViewController(vc, animated: true)
    }

}
