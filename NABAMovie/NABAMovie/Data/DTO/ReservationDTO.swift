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
    let genre: [String]            // 영화 장르 리스트
    let member: Int                // 예약 인원 수
    let posterURL: String          // 영화 포스터 이미지 URL
    let reservationTime: String    // 예약한 시간 (ex: "11:30")
    let title: String              // 영화 제목

    // MARK: - Entity 변환
    /// DTO를 앱 내부 모델(Reservation)로 변환하는 메소드
    func toEntity() -> Reservation {
        return Reservation(
            genre: genre,
            member: member,
            posterURL: posterURL,
            reservationTime: reservationTime,
            title: title
        )
    }
}
