//
//  FirestoreManager.swift
//  WordWideWeb
//
//  Created by David Jang on 5/17/24.
//

//import Foundation
//import FirebaseFirestore
//
//final class FirestoreManager {
//    static let shared = FirestoreManager()
//    private init() {}
//    
//    private let db = Firestore.firestore()
//    
//    // 사용자 정보 저장
//    func saveUser(user: User) async throws {
//        try await db.collection("users").document(user.uid).setData([
//            "uid": user.uid,
//            "email": user.email,
//            "displayName": user.displayName ?? "",
//            "photoURL": user.photoURL ?? ""
//        ])
//    }
//    
//    // 사용자 정보 가져오기
//    func fetchUser(uid: String) async throws -> User? {
//        let document = try await fetchDocument(collection: "users", documentID: uid)
//        return try document.data(as: User.self)
//    }
//    
//    // 이메일로 사용자 검색
//    func searchUserByEmail(email: String) async throws -> [User] {
//        let querySnapshot = try await db.collection("users")
//            .whereField("email", isEqualTo: email)
//            .getDocuments()
//        return try querySnapshot.documents.compactMap { try $0.data(as: User.self) }
//    }
//    
//    // 이름으로 사용자 ㄱ섬새
//    func searchUserByName(name: String) async throws -> [User] {
//        let querySnapshot = try await db.collection("users")
//            .whereField("displayName", isEqualTo: name)
//            .getDocuments()
//        return try querySnapshot.documents.compactMap { try $0.data(as: User.self) }
//    }
//    
//    // 단어장 생성
//    func createWordbook(wordbook: Wordbook) async throws {
//        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
//            do {
//                try db.collection("wordbooks").document(wordbook.id).setData(from: wordbook) { error in
//                    if let error = error {
//                        continuation.resume(throwing: error)
//                    } else {
//                        continuation.resume(returning: ())
//                    }
//                }
//            } catch {
//                continuation.resume(throwing: error)
//            }
//        }
//    }
//    
//    // 단어장 목록 가져오기
//    func fetchWordbooks(for userId: String) async throws -> [Wordbook] {
//        let querySnapshot = try await fetchDocuments(collection: "wordbooks", field: "ownerId", value: userId)
//        return try querySnapshot.documents.compactMap { try $0.data(as: Wordbook.self) }
//    }
//    
//    // 단어 저장
//    func addWord(to wordbookId: String, word: Word) async throws {
//        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
//            do {
//                try db.collection("wordbooks").document(wordbookId).collection("words").document(word.id).setData(from: word) { error in
//                    if let error = error {
//                        continuation.resume(throwing: error)
//                    } else {
//                        continuation.resume(returning: ())
//                    }
//                }
//            } catch {
//                continuation.resume(throwing: error)
//            }
//        }
//    }
//    
//    // 단어 가져오기
//    func fetchWords(from wordbookId: String) async throws -> [Word] {
//        let querySnapshot = try await fetchCollectionDocuments(collection: "wordbooks/\(wordbookId)/words")
//        return try querySnapshot.documents.compactMap { try $0.data(as: Word.self) }
//    }
//    
//    // 단어장 공개/비공개 설정
//    func setWordbookVisibility(wordbookId: String, isPublic: Bool) async throws {
//        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
//            db.collection("wordbooks").document(wordbookId).updateData(["isPublic": isPublic]) { error in
//                if let error = error {
//                    continuation.resume(throwing: error)
//                } else {
//                    continuation.resume(returning: ())
//                }
//            }
//        }
//    }
//    
//    // 단어장 공유
//    func shareWordbook(wordbookId: String, with userId: String) async throws {
//        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
//            db.collection("wordbooks").document(wordbookId).updateData([
//                "sharedWith": FieldValue.arrayUnion([userId])
//            ]) { error in
//                if let error = error {
//                    continuation.resume(throwing: error)
//                } else {
//                    continuation.resume(returning: ())
//                }
//            }
//        }
//    }
//    
//    // MARK: - Helper Methods
//    
//    private func fetchDocument(collection: String, documentID: String) async throws -> DocumentSnapshot {
//        return try await withCheckedThrowingContinuation { continuation in
//            db.collection(collection).document(documentID).getDocument { document, error in
//                if let document = document, document.exists {
//                    continuation.resume(returning: document)
//                } else {
//                    continuation.resume(throwing: error ?? URLError(.badServerResponse))
//                }
//            }
//        }
//    }
//    
//    private func fetchDocuments(collection: String, field: String, value: String) async throws -> QuerySnapshot {
//        return try await withCheckedThrowingContinuation { continuation in
//            db.collection(collection).whereField(field, isEqualTo: value).getDocuments { querySnapshot, error in
//                if let querySnapshot = querySnapshot {
//                    continuation.resume(returning: querySnapshot)
//                } else {
//                    continuation.resume(throwing: error ?? URLError(.badServerResponse))
//                }
//            }
//        }
//    }
//    
//    private func fetchCollectionDocuments(collection: String) async throws -> QuerySnapshot {
//        return try await withCheckedThrowingContinuation { continuation in
//            db.collection(collection).getDocuments { querySnapshot, error in
//                if let querySnapshot = querySnapshot {
//                    continuation.resume(returning: querySnapshot)
//                } else {
//                    continuation.resume(throwing: error ?? URLError(.badServerResponse))
//                }
//            }
//        }
//    }
//}

import Foundation
import FirebaseFirestore

final class FirestoreManager {
    static let shared = FirestoreManager()
    private init() { }
    
    private let db = Firestore.firestore()

    
    func saveUser(user: User) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            db.collection("users").document(user.uid).setData([
                "uid": user.uid,
                "email": user.email,
                "displayName": user.displayName ?? "",
                "photoURL": user.photoURL ?? ""
            ]) { error in
                if let error = error {
                    print("Error saving user to Firestore: \(error)")
                    continuation.resume(throwing: error)
                } else {
                    print("User saved to Firestore: \(user)")
                    continuation.resume(returning: ())
                }
            }
        }
    }

    
    // 사용자 정보 가져오기
    func fetchUser(uid: String) async throws -> User? {
        let document = try await fetchDocument(collection: "users", documentID: uid)
        return try document.data(as: User.self)
    }
    
    // 이메일로 사용자 검색
    func searchUserByEmail(email: String) async throws -> [User] {
        let querySnapshot = try await fetchDocuments(collection: "users", field: "email", value: email)
        return try querySnapshot.documents.compactMap { try $0.data(as: User.self) }
    }
    
    // 이름으로 사용자 검색
    func searchUserByName(name: String) async throws -> [User] {
        let querySnapshot = try await fetchDocuments(collection: "users", field: "displayName", value: name)
        return try querySnapshot.documents.compactMap { try $0.data(as: User.self) }
    }
    
    // 단어장 생성
    func createWordbook(wordbook: Wordbook) async throws {
        let data = try Firestore.Encoder().encode(wordbook)
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            db.collection("wordbooks").document(wordbook.id).setData(data) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }
    
    // 단어장 목록 가져오기
    func fetchWordbooks(for userId: String) async throws -> [Wordbook] {
        let querySnapshot = try await fetchDocuments(collection: "wordbooks", field: "ownerId", value: userId)
        return try querySnapshot.documents.compactMap { try $0.data(as: Wordbook.self) }
    }
    
    // 단어 저장
    func addWord(to wordbookId: String, word: Word) async throws {
        let data = try Firestore.Encoder().encode(word)
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            db.collection("wordbooks").document(wordbookId).collection("words").document(word.id).setData(data) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }
    
    // 단어 가져오기
    func fetchWords(from wordbookId: String) async throws -> [Word] {
        let querySnapshot = try await fetchCollectionDocuments(collection: "wordbooks/\(wordbookId)/words")
        return try querySnapshot.documents.compactMap { try $0.data(as: Word.self) }
    }
    
    // 단어장 공개/비공개 설정
    func setWordbookVisibility(wordbookId: String, isPublic: Bool) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            db.collection("wordbooks").document(wordbookId).updateData(["isPublic": isPublic]) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }
    
    // 단어장 공유
    func shareWordbook(wordbookId: String, with userId: String) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            db.collection("wordbooks").document(wordbookId).updateData([
                "sharedWith": FieldValue.arrayUnion([userId])
            ]) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func fetchDocument(collection: String, documentID: String) async throws -> DocumentSnapshot {
        return try await withCheckedThrowingContinuation { continuation in
            db.collection(collection).document(documentID).getDocument { document, error in
                if let document = document, document.exists {
                    continuation.resume(returning: document)
                } else {
                    continuation.resume(throwing: error ?? URLError(.badServerResponse))
                }
            }
        }
    }
    
    private func fetchDocuments(collection: String, field: String, value: String) async throws -> QuerySnapshot {
        return try await withCheckedThrowingContinuation { continuation in
            db.collection(collection).whereField(field, isEqualTo: value).getDocuments { querySnapshot, error in
                if let querySnapshot = querySnapshot {
                    continuation.resume(returning: querySnapshot)
                } else {
                    continuation.resume(throwing: error ?? URLError(.badServerResponse))
                }
            }
        }
    }
    
    private func fetchCollectionDocuments(collection: String) async throws -> QuerySnapshot {
        return try await withCheckedThrowingContinuation { continuation in
            db.collection(collection).getDocuments { querySnapshot, error in
                if let querySnapshot = querySnapshot {
                    continuation.resume(returning: querySnapshot)
                } else {
                    continuation.resume(throwing: error ?? URLError(.badServerResponse))
                }
            }
        }
    }
}

