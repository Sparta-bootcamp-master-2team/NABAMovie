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
    private let factory: MyPageFactory
    private(set) weak var parentCoordinator: TabBarCoordinator?
    private var currentCoordinators: [Coordinator] = []

    init(
        navigationController: UINavigationController,
        factory: MyPageFactory,
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
        let vc = factory.makeMyPageViewController(coordinator: self)
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
    
    func showMore(item: [any CellConfigurable]) {
        let vc = factory.makeMovieListViewController(item: item, coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func didLogout() {
        parentCoordinator?.parentCoordinator?.start()
    }

}
