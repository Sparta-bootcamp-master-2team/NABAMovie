//
//  MyPageDIContainer.swift
//  NABAMovie
//
//  Created by 박주성 on 4/30/25.
//

import UIKit

final class MyPageDIContainer {
    func makeMyPageViewController(coordinator: MyPageCoordinator) -> MyPageViewController {
        
        let firebaseService = FirebaseService()
        
        let favoriteMovieRepository = FavoriteMovieRepositoryImpl(firebaseService: firebaseService)
        let reservationRepository = ReservationRepositoryImpl(firebaseService: firebaseService)
        let authRepository = FirebaseAuthRepositoryImpl(firebaseService: firebaseService)
        
        let fetchFavoriteMoviesusecase = FetchFavoriteMoviesUseCase(favoriteMovieRepository: favoriteMovieRepository)
        let fetchReservationUseCase = FetchReservationsUseCase(reservationRepository: reservationRepository)
        let logoutUseCase = LogoutUseCase(repository: authRepository)
        
        let viewModel = MyPageViewModel(
            fetchFavoriteMoviesUseCase: fetchFavoriteMoviesusecase,
            fetchReservationUseCase: fetchReservationUseCase,
            logoutUseCase: logoutUseCase)
        
        return MyPageViewController(viewModel: viewModel, coordinator: coordinator)
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
    
    func makeMovieListViewController(
        item: [CellConfigurable],
        coordinator: MyPageCoordinator
    ) -> MovieListViewController {
        let listVM = MovieListViewModel(item: item)
        return MovieListViewController(viewModel: listVM, coordinator: coordinator)
    }

}
