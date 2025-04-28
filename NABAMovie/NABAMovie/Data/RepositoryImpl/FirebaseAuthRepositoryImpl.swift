//
//  FirebaseAuthRepositoryImpl.swift
//  NABAMovie
//
//  Created by 양원식 on 4/28/25.
//
import FirebaseAuth
import FirebaseFirestore

final class FirebaseAuthRepositoryImpl: AuthRepository {
    func login(email: String, password: String) async throws -> User {
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        let uid = authResult.user.uid

        let snapshot = try await Firestore.firestore()
            .collection("users")
            .document(uid)
            .getDocument()

        guard let data = snapshot.data() else {
            throw NSError(domain: "LoginError", code: 999, userInfo: [NSLocalizedDescriptionKey: "사용자 정보가 없습니다."])
        }

        let userDTO = UserDTO(
            id: uid,
            username: data["username"] as? String ?? ""
        )

        return userDTO.toDomain()
    }

    func logout() async throws {
        try Auth.auth().signOut()
    }

    func register(email: String, password: String, username: String) async throws -> User {
        // (회원가입은 나중에 이어서)
        fatalError("Not implemented")
    }
}
