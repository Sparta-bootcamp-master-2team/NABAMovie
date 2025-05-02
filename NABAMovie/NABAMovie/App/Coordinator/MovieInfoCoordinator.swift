//
//  MovieInfoCoordinator.swift
//  NABAMovie
//
//  Created by 박주성 on 5/1/25.
//

import UIKit

protocol MovieInfoCoordinatorProtocol: Coordinator {
    func showBookingPage(movie: MovieEntity)
    func didSuccessBooking(movie: Reservation)
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
    
    func didSuccessBooking(movie: Reservation) {
        navigationController.popViewController(animated: false)
        navigationController.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }

            // 1. MovieInfoCoordinator → 중간 부모 (Home/Search/MyPage 중 하나)
            guard let midCoordinator = self.parentCoordinator else { return }

            // 2. 중간 부모 → TabBarCoordinator
            if let tabBarCoordinator = (midCoordinator as? HomeCoordinator)?.parentCoordinator
                ?? (midCoordinator as? SearchCoordinator)?.parentCoordinator
                ?? (midCoordinator as? MyPageCoordinator)?.parentCoordinator {
                
                tabBarCoordinator.showMyReservationDetail(movie: movie)
            }
        }
    }
}
