//
//  CancelReservationUseCase.swift
//  NABAMovie
//
//  Created by 양원식 on 4/30/25.
//

final class CancelReservationUseCase {
    private let repository: ReservationRepository

    init(repository: ReservationRepository) {
        self.repository = repository
    }

    func execute(userID: String, reservationID: String) async throws {
        try await repository.cancelReservation(userID: userID, reservationID: reservationID)
    }
}
