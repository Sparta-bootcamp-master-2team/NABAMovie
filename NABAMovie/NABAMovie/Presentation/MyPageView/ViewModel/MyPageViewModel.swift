//
//  MyPageViewModel.swift
//  NABAMovie
//
//  Created by MJ Dev on 4/30/25.
//

import Foundation

final class MyPageViewModel {
    
    private let fetchFavoriteMoviesUseCase: FetchFavoriteMoviesUseCase
    private let fetchReservationUseCase: FetchReservationsUseCase
    private let logoutUseCase: LogoutUseCase
    
    var successFetchMyPageItem: (@MainActor ([Reservation],[MovieEntity]) -> Void)?
    var failedFetchMyPageItem: (@MainActor () -> Void)?
    var failedLogout: (@MainActor () -> Void)?
    
    init(fetchFavoriteMoviesUseCase: FetchFavoriteMoviesUseCase,
         fetchReservationUseCase: FetchReservationsUseCase, logoutUseCase: LogoutUseCase) {
        self.fetchFavoriteMoviesUseCase = fetchFavoriteMoviesUseCase
        self.fetchReservationUseCase = fetchReservationUseCase
        self.logoutUseCase = logoutUseCase
    }
    
    // 마이페이지 정보 병렬 호출
    func fetchMyPageItem() {
        let firebaseService = FirebaseService()
        Task {
            do {
                let uid = try firebaseService.getCurrentUserId()
                async let favorites = fetchFavoriteMoviesUseCase.execute(userId: uid).get()
                async let reservations = fetchReservationUseCase.execute(userId: uid).get()
                try await successFetchMyPageItem?(reservations, favorites)
            } catch {
                await failedFetchMyPageItem?()
            }
        }
    }
    
    func logout() {
        Task {
            let result = await logoutUseCase.execute()
            if !result {
                await failedLogout?()
            }
        }
    }
}
