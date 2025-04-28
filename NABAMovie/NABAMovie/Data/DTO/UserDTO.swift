//
//  UserDTO.swift
//  NABAMovie
//
//  Created by 양원식 on 4/28/25.
//

import Foundation

struct UserDTO: Codable {
    let id: String
    let username: String

    func toDomain() -> User {
        return User(id: id, username: username)
    }
}
