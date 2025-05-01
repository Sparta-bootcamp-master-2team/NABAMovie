//
//  MyPageCoordinator.swift
//  NABAMovie
//
//  Created by 박주성 on 4/30/25.
//

import UIKit

protocol MyPageCoordinatorProtocol: Coordinator {
    func showMovieInfo(movie: MovieEntity)
    func showMore(item: [CellConfigurable])
    func didLogout()
}

final class MyPageCoordinator: MyPageCoordinatorProtocol {
    private let navigationController: UINavigationController
    private let diContainer: MyPageFactory
    private let parentCoordinator: TabBarCoordinator
    private var currentCoordinators: [Coordinator] = []

    init(
        navigationController: UINavigationController,
        diContainer: MyPageFactory,
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
        let movieInfoCoordinator = MovieInfoCoordinator(
            navigationController: self.navigationController,
            diContainer: MovieInfoFactory(),
            parentCoordinator: self,
            movie: movie
        )
        
        currentCoordinators = [movieInfoCoordinator]
        movieInfoCoordinator.start()
    }
    
    func showMore(item: [any CellConfigurable]) {
        let vc = diContainer.makeMovieListViewController(item: item, coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func didLogout() {
        parentCoordinator.parentCoordinator.start()
    }

}
