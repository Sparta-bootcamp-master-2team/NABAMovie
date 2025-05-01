//
//  HomeFactory.swift
//  NABAMovie
//
//  Created by 박주성 on 4/30/25.
//

import UIKit

final class HomeFactory {
    func makeHomeViewController(coordinator: HomeCoordinator) -> HomeViewController {
        let repository = MovieRepositoryImpl(networkManager: MovieNetworkManager())
        let usecase = FetchHomeScreenMoviesUseCase(repository: repository)
        let viewModel = HomeViewModel(usecase: usecase)
        return HomeViewController(viewModel: viewModel, coordinator: coordinator)
    }
}
