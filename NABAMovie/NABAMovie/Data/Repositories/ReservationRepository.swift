//
//  Untitled.swift
//  NABAMovie
//
//  Created by 양원식 on 4/28/25.
//

import Foundation
import UIKit

protocol ReservationRepository {
    func fetchReservations(userID: String) async throws -> [Reservation]
    func makeReservation(userID: String, reservation: Reservation) async throws
}
