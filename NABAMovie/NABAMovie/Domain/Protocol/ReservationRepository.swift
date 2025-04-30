//
//  Untitled.swift
//  NABAMovie
//
//  Created by 양원식 on 4/28/25.
//

import Foundation
import UIKit

// MARK: - ReservationRepository
/// 영화 예약(Reservation) 데이터를 관리하는 Repository 프로토콜
protocol ReservationRepository {
    
    // MARK: - 예약 목록 조회
    /// 사용자의 예약 내역을 조회하는 메소드
    /// - Parameter userID: 사용자 고유 식별자 (UID)
    /// - Returns: 예약 목록 ([Reservation])
    func fetchReservations(userID: String) async throws -> [Reservation]
    
    // MARK: - 예약 추가
    /// 사용자의 예약 목록에 새로운 예약을 추가하는 메소드
    /// - Parameters:
    ///   - userID: 사용자 고유 식별자 (UID)
    ///   - reservation: 추가할 예약 정보 (Reservation)
    func makeReservation(userID: String, reservation: Reservation) async throws
    
    
    func cancelReservation(userID: String, reservationID: String) async throws

}

