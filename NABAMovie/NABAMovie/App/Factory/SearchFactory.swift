//
//  SearchFactory.swift
//  NABAMovie
//
//  Created by 박주성 on 4/30/25.
//

import UIKit

final class SearchFactory {
    func makeMovieSearchViewController(coordinator: SearchCoordinator) -> MovieSearchViewController {
        let networkManager = MovieNetworkManager()
        let repository = MovieRepositoryImpl(networkManager: networkManager)
        let usecase = FetchSearchMoviesUseCase(repository: repository)
        let viewModel = MovieSearchViewModel(fetchSearchUseCase: usecase)
        let vc = MovieSearchViewController(viewModel: viewModel, coordinator: coordinator)
        return vc
    }
}
