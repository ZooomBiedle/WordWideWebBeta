//
//  FirestoreManager.swift
//  WordWideWeb
//
//  Created by David Jang on 5/14/24.
//

import FirebaseFirestore

final class FirestoreManager {
    
    static let shared = FirestoreManager()
    private init() { }
    
    private let db = Firestore.firestore()
    
    func addUser(user: AuthDataResultModel, nickname: String) async throws {
        let userData: [String: Any] = [
            "uid": user.uid,
            "email": user.email ?? "",
            "nickname": nickname
        ]
        try await db.collection("users").document(user.uid).setData(userData)
    }
    
    func searchUsers(query: String, completion: @escaping (Result<[AuthDataResultModel], Error>) -> Void) {
        db.collection("users").whereField("email", isEqualTo: query).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                var users: [AuthDataResultModel] = []
                for document in snapshot?.documents ?? [] {
                    if let user = AuthDataResultModel(document: document) {
                        users.append(user)
                    }
                }
                completion(.success(users))
            }
        }
    }

    func checkEmailExists(email: String) async throws -> Bool {
        let querySnapshot = try await db.collection("users").whereField("email", isEqualTo: email).getDocuments()
        return !querySnapshot.isEmpty
    }
}

extension AuthDataResultModel {
    init?(document: DocumentSnapshot) {
        let data = document.data()
        guard let uid = data?["uid"] as? String else { return nil }
        self.uid = uid
        self.email = data?["email"] as? String
        self.photoUrl = data?["photoUrl"] as? String
    }
}
