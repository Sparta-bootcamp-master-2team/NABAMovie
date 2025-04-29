//
//  FetchReservationUseCase.swift
//  NABAMovie
//
//  Created by 양원식 on 4/28/25.
//

import Foundation

// MARK: - FetchReservationsUseCase
/// 사용자의 예약 목록을 조회하는 유스케이스
final class FetchReservationsUseCase {
    
    // MARK: - Properties
    private let reservationRepository: ReservationRepository

    // MARK: - Initializer
    init(reservationRepository: ReservationRepository) {
        self.reservationRepository = reservationRepository
    }

    // MARK: - Execute
    /// 사용자 ID를 기반으로 예약 목록을 조회하는 메소드
    /// - Parameter userId: 사용자 고유 식별자 (UID)
    /// - Returns: 예약 목록 조회 결과 (Result<[Reservation], Error>)
    ///
    /// Usage Example:
    /// ```
    /// let result = await fetchReservationsUseCase.execute(userId: "user-uid")
    /// switch result {
    /// case .success(let reservations):
    ///     print(reservations.count)
    /// case .failure(let error):
    ///     print(error.localizedDescription)
    /// }
    /// ```
    func execute(userId: String) async -> Result<[Reservation], Error> {
        do {
            let reservations = try await reservationRepository.fetchReservations(userID: userId)
            return .success(reservations)
        } catch {
            return .failure(error)
        }
    }
}
