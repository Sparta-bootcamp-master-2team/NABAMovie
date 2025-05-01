//
//  SearchDIContainer.swift
//  NABAMovie
//
//  Created by 박주성 on 4/30/25.
//

import UIKit

final class SearchDIContainer {
    func makeMovieSearchViewController(coordinator: SearchCoordinator) -> MovieSearchViewController {
        let networkManager = MovieNetworkManager()
        let repository = MovieRepositoryImpl(networkManager: networkManager)
        let usecase = FetchSearchMoviesUseCase(repository: repository)
        let viewModel = MovieSearchViewModel(fetchSearchUseCase: usecase)
        let vc = MovieSearchViewController(viewModel: viewModel, coordinator: coordinator)
        return vc
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
