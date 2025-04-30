//
//  ReservationDTO.swift
//  NABAMovie
//
//  Created by 양원식 on 4/29/25.
//

import Foundation

// MARK: - ReservationDTO
/// Firestore에 저장하거나 가져오는 예약 데이터 모델 (DTO)
struct ReservationDTO: Codable {
    let reservationID: String      // 문서 ID와 동일한 고유 예약 ID
    let genre: [String]            // 영화 장르 리스트
    let member: Int                // 예약 인원 수
    let posterURL: String          // 영화 포스터 이미지 URL
    let reservationTime: String    // 예약한 시간 (ex: "11:30")
    let title: String              // 영화 제목

    // MARK: - Entity 변환
    func toEntity() -> Reservation {
        return Reservation(
            reservationID: reservationID,
            genre: genre,
            member: member,
            posterURL: posterURL,
            reservationTime: reservationTime,
            title: title
        )
    }
}

