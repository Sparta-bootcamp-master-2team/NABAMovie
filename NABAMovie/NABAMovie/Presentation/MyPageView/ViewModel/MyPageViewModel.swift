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
    
    var favorites: [MovieEntity] = []
    var reservations: [Reservation] = []
    var user: User?
    
    var successFetchMyPageItem: (@MainActor ([Reservation],[MovieEntity]) -> Void)?
    var failedFetchMyPageItem: (@MainActor () -> Void)?
    var failedLogout: (@MainActor () -> Void)?
    var successFetchUserInfo: (@MainActor (User) -> Void)?
    var failedFetchUserInfo: (@MainActor () -> Void)?
    var successLogout: (@MainActor () -> Void)?
    
    init(fetchFavoriteMoviesUseCase: FetchFavoriteMoviesUseCase,
         fetchReservationUseCase: FetchReservationsUseCase, logoutUseCase: LogoutUseCase) {
        self.fetchFavoriteMoviesUseCase = fetchFavoriteMoviesUseCase
        self.fetchReservationUseCase = fetchReservationUseCase
        self.logoutUseCase = logoutUseCase
    }
    
    // 사용자 정보 불러오기
    func fetchUserInfo() {
        let firebaseService = FirebaseService()
        Task {
            do {
                let uid = try firebaseService.getCurrentUserId()
                let user = try await firebaseService.fetchUser(uid: uid)
                self.user = user
                await successFetchUserInfo?(self.user ?? User(id: "0", username: "실패"))
            } catch {
                await failedFetchUserInfo?()
            }
        }
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
    
    // 뷰모델에 데이터 저장
    func savePageItems(reseravations: [Reservation], favorites: [MovieEntity]) {
        self.favorites = favorites
        self.reservations = reseravations
    }
    
    // 로그아웃
    func logout() {
        Task {
            let result = await logoutUseCase.execute()
            result ? await successLogout?() : await failedLogout?()
        }
    }
}
