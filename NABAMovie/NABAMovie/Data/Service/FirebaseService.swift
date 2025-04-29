//
//  FirebaseService.swift
//  NABAMovie
//
//  Created by 양원식 on 4/28/25.
//

import FirebaseAuth
import FirebaseFirestore

final class FirebaseService: FirebaseServiceProtocol {
    func signIn(email: String, password: String) async throws -> User {
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return try await fetchUser(uid: authResult.user.uid)
    }
    
    func signUp(email: String, password: String, username: String) async throws -> User {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        let uid = authResult.user.uid
        try await Firestore.firestore().collection("users").document(uid).setData([
            "username": username
        ])
        return User(id: uid, username: username)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func fetchUser(uid: String) async throws -> User {
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        guard let data = snapshot.data(),
              let username = data["username"] as? String else {
            throw NSError(domain: "UserFetchError", code: 999, userInfo: [NSLocalizedDescriptionKey: "사용자 정보 없음"])
        }
        return User(id: uid, username: username)
    }
    
    func fetchReservations(for userId: String) async throws -> [ReservationDTO] {
        let snapshot = try await Firestore.firestore()
            .collection("users")
            .document(userId)
            .collection("reservations")
            .getDocuments()
        
        let reservations: [ReservationDTO] = snapshot.documents.compactMap { document in
            try? document.data(as: ReservationDTO.self)
        }
        
        return reservations
    }
    
    func makeReservation(for userId: String, reservation: ReservationDTO) async throws {
        try await Firestore.firestore()
            .collection("users")
            .document(userId)
            .collection("reservations")
            .addDocument(data: [
                "genre": reservation.genre,
                "member": reservation.member,
                "posterURL": reservation.posterURL,
                "reservationTime": reservation.reservationTime,
                "title": reservation.title
            ])
    }
    
}
