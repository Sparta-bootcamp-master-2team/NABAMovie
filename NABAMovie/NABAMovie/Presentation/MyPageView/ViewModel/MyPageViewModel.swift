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
    
    var successFetchMyPageItem: (@MainActor ([Reservation],[MovieEntity]) -> Void)?
    var failedFetchMyPageItem: (@MainActor () -> Void)?
    
    init(fetchFavoriteMoviesUseCase: FetchFavoriteMoviesUseCase,
         fetchReservationUseCase: FetchReservationsUseCase) {
        self.fetchFavoriteMoviesUseCase = fetchFavoriteMoviesUseCase
        self.fetchReservationUseCase = fetchReservationUseCase
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
}
