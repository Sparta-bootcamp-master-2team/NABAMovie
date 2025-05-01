//
//  MovieInfoFactory.swift
//  NABAMovie
//
//  Created by 박주성 on 5/1/25.
//

import UIKit

final class MovieInfoFactory {
    func makeMovieInfoViewController(
        movie: MovieEntity,
        coordinator: MovieInfoCoordinator
    ) -> MovieInfoViewController {
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
