//
//  Reservation.swift
//  NABAMovie
//
//  Created by 양원식 on 4/28/25.
//

import Foundation

struct Reservation: Hashable {
    let reservationID: String
    let genre: [String]
    let member: Int
    let posterURL: String
    let reservationTime: String
    let title: String
}

extension Reservation: CellConfigurable { }
