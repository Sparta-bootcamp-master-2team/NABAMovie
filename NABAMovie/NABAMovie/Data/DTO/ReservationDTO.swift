//
//  ReservationDTO.swift
//  NABAMovie
//
//  Created by 양원식 on 4/29/25.
//

import Foundation

struct ReservationDTO: Codable {
    let genre: [String]
    let member: Int
    let posterURL: String
    let reservationTime: String
    let title: String

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
