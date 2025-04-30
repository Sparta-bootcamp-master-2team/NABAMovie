//
//  ReservationDetailViewModel.swift
//  NABAMovie
//
//  Created by MJ Dev on 4/30/25.
//

import Foundation

final class ReservationDetailViewModel {
    
    private let cancelReservationUseCase: CancelReservationUseCase
    // 임시로 일단 불러옴
    private let firebaseService = FirebaseService()
    private let reservationItem: Reservation
    
    init(cancelReservationUseCase: CancelReservationUseCase, reservationItem: Reservation) {
        self.cancelReservationUseCase = cancelReservationUseCase
        self.reservationItem = reservationItem
    }
    
    var failedCancelReservation: (@MainActor () -> Void)?
    var successCancelReservation: (@MainActor () -> Void)?
    
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
