//
//  ReservationRepositoryImpl.swift
//  NABAMovie
//
//  Created by 양원식 on 4/29/25.
//

import Foundation

final class ReservationRepositoryImpl: ReservationRepository {
    private let firebaseService: FirebaseServiceProtocol

    init(firebaseService: FirebaseServiceProtocol) {
        self.firebaseService = firebaseService
    }

    func fetchReservations(userID userId: String) async throws -> [Reservation] {
        let dtos = try await firebaseService.fetchReservations(for: userId)
        return dtos.map { $0.toEntity() }
    }

    func makeReservation(userID userId: String, reservation: Reservation) async throws {
        let dto = ReservationDTO(
            genre: reservation.genre,
            member: reservation.member,
            posterURL: reservation.posterURL,
            reservationTime: reservation.reservationTime,
            title: reservation.title
        )
        try await firebaseService.makeReservation(for: userId, reservation: dto)
    }
}
