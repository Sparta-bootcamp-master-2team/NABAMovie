//
//  ReservationDetailViewModel.swift
//  NABAMovie
//
//  Created by MJ Dev on 4/30/25.
//

import Foundation

final class ReservationDetailViewModel {
    
    // 주입되는 것 UseCase, Reservation
    private let cancelReservationUseCase: CancelReservationUseCase
    let reservationItem: Reservation
    // 임시로 일단 불러옴
    private let firebaseService = FirebaseService()
    
    init(cancelReservationUseCase: CancelReservationUseCase, reservationItem: Reservation) {
        self.cancelReservationUseCase = cancelReservationUseCase
        self.reservationItem = reservationItem
    }
    
    // VC에 showAlert()로 바인딩
    var failedCancelReservation: (@MainActor () -> Void)?
    var successCancelReservation: (@MainActor () -> Void)?
    
    // 예매취소하기
    func cancelReservation() {
        Task {
            do {
                let uid = try firebaseService.getCurrentUserId()
                try await cancelReservationUseCase.execute(userID: uid, reservationID: reservationItem.reservationID)
                await successCancelReservation?()
            } catch {
                await failedCancelReservation?()
            }
        }
    }
}
