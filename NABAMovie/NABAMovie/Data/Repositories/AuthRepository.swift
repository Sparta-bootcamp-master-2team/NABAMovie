//
//  AuthRepository.swift
//  NABAMovie
//
//  Created by 양원식 on 4/28/25.
//

import Foundation
import UIKit

protocol AuthRepository {
    func login(email: String, password: String) async throws -> User
    func logout() async throws
    func register(email: String, password: String, username: String) async throws -> User
}
