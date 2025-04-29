//
//  FetchReservationUseCase.swift
//  NABAMovie
//
//  Created by 양원식 on 4/28/25.
//

import Foundation

final class FetchReservationsUseCase {
    private let reservationRepository: ReservationRepository

    init(reservationRepository: ReservationRepository) {
        self.reservationRepository = reservationRepository
    }

    func execute(userId: String) async -> Result<[Reservation], Error> {
        do {
            let reservations = try await reservationRepository.fetchReservations(userID: userId)
            return .success(reservations)
        } catch {
            return .failure(error)
        }
    }
}
