//
//  MyPageDIContainer.swift
//  NABAMovie
//
//  Created by 박주성 on 4/30/25.
//

import UIKit

final class MyPageDIContainer {
    func makeMyPageViewController() -> MyPageViewController {
        
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
        
        return MyPageViewController(viewModel: viewModel)
    }
}
