//
//  MyPageCoordinator.swift
//  NABAMovie
//
//  Created by 박주성 on 4/30/25.
//

import UIKit

protocol MyPageCoordinatorProtocol: Coordinator {
    func showMovieInfo(movie: MovieEntity)
    func showReservation(movie: Reservation)
    func showMore(item: [CellConfigurable])
}

final class MyPageCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let diContainer: MyPageDIContainer
    private let parentCoordinator: TabBarCoordinator

    init(
        navigationController: UINavigationController,
        diContainer: MyPageDIContainer,
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
        let vc = diContainer.makeMyPageViewController(coordinator: self)
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func showMovieInfo(movie: MovieEntity) {
        let vc = diContainer.makeMovieInfoController(movie: movie)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showReservation(movie: Reservation) {
        print(1)
    }
    
    func showMore(item: [any CellConfigurable]) {
        let vc = diContainer.makeMovieListViewController(item: item, coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }

}
