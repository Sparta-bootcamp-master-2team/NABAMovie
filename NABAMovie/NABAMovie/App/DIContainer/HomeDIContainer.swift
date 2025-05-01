//
//  HomeDIContainer.swift
//  NABAMovie
//
//  Created by 박주성 on 4/30/25.
//

import UIKit

final class HomeDIContainer {
    func makeHomeViewController(coordinator: HomeCoordinator) -> HomeViewController {
        let repository = MovieRepositoryImpl(networkManager: MovieNetworkManager())
        let usecase = FetchHomeScreenMoviesUseCase(repository: repository)
        let viewModel = HomeViewModel(usecase: usecase)
        return HomeViewController(viewModel: viewModel, coordinator: coordinator)
    }
    
    func makeMovieInfoController(movie: MovieEntity) -> MovieInfoViewController {
        let networkManager = MovieNetworkManager()
        let firebaseService = FirebaseService()
        
        let movieRepository = MovieRepositoryImpl(networkManager: networkManager)
        let favoriteMovieRepository = FavoriteMovieRepositoryImpl(firebaseService: firebaseService)
        
        let movieStillsUseCase = FetchMovieStillsUseCase(repository: movieRepository)
        let addFavoriteMovieUseCase = AddFavoriteMovieUseCase(repository: favoriteMovieRepository)
        let removeFavoriteMovieUseCase = RemoveFavoriteMovieUseCase(repository: favoriteMovieRepository)
        
        let viewModel = MovieInfoViewModel(
            movieDetail: movie,
            movieStillsUseCase: movieStillsUseCase,
            addFavoriteMovieUseCase: addFavoriteMovieUseCase,
            removeFavoriteMovieUseCase: removeFavoriteMovieUseCase
        )
        return MovieInfoViewController(viewModel: viewModel)
    }
}
