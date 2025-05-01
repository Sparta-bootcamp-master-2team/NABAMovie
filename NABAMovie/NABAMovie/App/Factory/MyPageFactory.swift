//
//  MyPageFactory.swift
//  NABAMovie
//
//  Created by 박주성 on 4/30/25.
//

import UIKit

final class MyPageFactory {
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
    
    func makeMovieListViewController(
        item: [CellConfigurable],
        coordinator: MyPageCoordinator
    ) -> MovieListViewController {
        let listVM = MovieListViewModel(item: item)
        return MovieListViewController(viewModel: listVM, coordinator: coordinator)
    }
    
    func makeReservationDetailViewController(
        movie: Reservation,
        coordinator: MyPageCoordinator
    ) -> ReservationDetailViewController {
        let firebaseService = FirebaseService()
        let repository = ReservationRepositoryImpl(firebaseService: firebaseService)
        let usecase = CancelReservationUseCase(repository: repository)
        let viewModel = ReservationDetailViewModel(cancelReservationUseCase: usecase, reservationItem: movie)
        
        return ReservationDetailViewController(viewModel: viewModel, coordinator: coordinator)
    }

}
