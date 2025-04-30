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
    
    init(cancelReservationUseCase: CancelReservationUseCase) {
        self.cancelReservationUseCase = cancelReservationUseCase
    }
    
    var failedCancelReservation: (() -> Void)?
    var successCancelReservation: (() -> Void)?
    
    func cancelReservation(userID: String, reservationID: String) {
        Task {
            do {
                let uid = try firebaseService.getCurrentUserId()
                try await cancelReservationUseCase.execute(userID: uid, reservationID: reservationID)
                await MainActor.run {
                    successCancelReservation?()
                }
            } catch {
                await MainActor.run {
                    failedCancelReservation?()
                }
            }
        }
    }
}
