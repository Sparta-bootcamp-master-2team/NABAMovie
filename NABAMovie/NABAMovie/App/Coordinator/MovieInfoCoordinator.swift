//
//  MovieInfoCoordinator.swift
//  NABAMovie
//
//  Created by 박주성 on 5/1/25.
//

import UIKit

protocol MovieInfoCoordinatorProtocol: Coordinator {
    func showBookingPage(movie: MovieEntity)
    func didSuccessBooking()
}

final class MovieInfoCoordinator: MovieInfoCoordinatorProtocol {
    
    private let movie: MovieEntity
    
    private let navigationController: UINavigationController
    private let factory: MovieInfoFactory
    private(set) weak var parentCoordinator: Coordinator?
    
    init(
        movie: MovieEntity,
        navigationController: UINavigationController,
        factory: MovieInfoFactory,
        parentCoordinator: Coordinator
    ) {
        self.movie = movie
        self.navigationController = navigationController
        self.factory = factory
        self.parentCoordinator = parentCoordinator
    }
    
    deinit {
        print("\(String(describing: Self.self)) 메모리 해제")
    }

    func start() {
        let vc = factory.makeMovieInfoViewController(
            movie: self.movie,
            coordinator: self
        )
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showBookingPage(movie: MovieEntity) {
        let vc = factory.maekBookingPageViewController(
            movie: movie,
            coordinator: self
        )
        navigationController.present(vc, animated: true)
    }
    
    func didSuccessBooking() {
        navigationController.dismiss(animated: true)
    }
}
