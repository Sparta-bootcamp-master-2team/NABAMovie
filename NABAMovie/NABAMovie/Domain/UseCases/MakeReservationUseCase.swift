//
//  MakeReservationUseCase.swift
//  NABAMovie
//
//  Created by 양원식 on 4/28/25.
//

import Foundation

// MARK: - MakeReservationUseCase
/// 사용자의 예약 정보를 추가하는 유스케이스
final class MakeReservationUseCase {
    
    // MARK: - Properties
    private let reservationRepository: ReservationRepository

    // MARK: - Initializer
    init(reservationRepository: ReservationRepository) {
        self.reservationRepository = reservationRepository
    }

    // MARK: - Execute
    /// 예약 추가 실행 메소드
    /// - Parameters:
    ///   - userId: 사용자 고유 식별자 (UID)
    ///   - reservation: 추가할 예약 정보 (Reservation)
    /// - Returns: 작업 결과 (성공 또는 에러)
    ///
    /// Usage Example:
    /// ```
    /// let reservation = Reservation(...)
    /// let result = await makeReservationUseCase.execute(userId: "user-uid", reservation: reservation)
    /// switch result {
    /// case .success:
    ///     print("예약 성공")
    /// case .failure(let error):
    ///     print(error.localizedDescription)
    /// }
    /// ```
    func execute(userId: String, reservation: Reservation) async -> Result<Void, Error> {
        do {
            try await reservationRepository.makeReservation(userID: userId, reservation: reservation)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
