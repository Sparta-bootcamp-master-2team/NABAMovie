//
//  ReservationRepositoryImpl.swift
//  NABAMovie
//
//  Created by 양원식 on 4/29/25.
//

import Foundation

// MARK: - ReservationRepositoryImpl
/// 영화 예약(Reservation) 기능을 FirebaseService를 통해 구현한 Repository 클래스
final class ReservationRepositoryImpl: ReservationRepository {
    
    // MARK: - Properties
    private let firebaseService: FirebaseServiceProtocol

    // MARK: - Initializer
    init(firebaseService: FirebaseServiceProtocol) {
        self.firebaseService = firebaseService
    }

    // MARK: - 예약 목록 조회
    /// 사용자 ID를 이용해 예약 내역을 조회하는 메소드
    /// - Parameter userId: 사용자 고유 식별자 (UID)
    /// - Returns: 예약 리스트 ([Reservation])
    func fetchReservations(userID userId: String) async throws -> [Reservation] {
        let dtos = try await firebaseService.fetchReservations(for: userId)
        return dtos.map { $0.toEntity() }
    }

    // MARK: - 예약 추가
    /// 사용자 ID를 이용해 새로운 예약 정보를 추가하는 메소드
    /// - Parameters:
    ///   - userId: 사용자 고유 식별자 (UID)
    ///   - reservation: 추가할 예약 정보 (Reservation)
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

