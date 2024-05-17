//
//  AuthenticationManager.swift
//  WordWideWeb
//
//  Created by David Jang on 5/14/24.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let displayName: String?
    let photoURL: String?
    
    init(user: FirebaseAuth.User) {
        self.uid = user.uid
        self.email = user.email
        self.displayName = user.displayName
        self.photoURL = user.photoURL?.absoluteString
    }
}

enum AuthProviderOption: String {
    case email = "password"
    case google = "google.com"
    case apple = "apple.com"
}

final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    private init() {}
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
    }

    // 변경된 이메일 중복 확인 메서드
    func checkEmailExists(email: String) async -> Bool {
        do {
            _ = try await Auth.auth().createUser(withEmail: email, password: "temporaryPassword")
            // 임시 사용자가 생성되면 삭제
            let user = Auth.auth().currentUser
            try await user?.delete()
            return false
        } catch let error as NSError {
            if let errorCode = AuthErrorCode.Code(rawValue: error.code), errorCode == .emailAlreadyInUse {
                return true
            } else {
                // 다른 에러 발생 시 false 반환
                return false
            }
        }
    }
    
    func saveUserToFirestore(uid: String, email: String, displayName: String?, photoURL: String?) async throws {
        let user = User(uid: uid, email: email, displayName: displayName, photoURL: photoURL)
        print("Saving user to Firestore: \(user)")
        try await FirestoreManager.shared.saveUser(user: user)
    }

    @discardableResult
    func createUser(email: String, password: String, displayName: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        let user = AuthDataResultModel(user: authDataResult.user)
        
        // 사용자 Display Name 업데이트
        let changeRequest = authDataResult.user.createProfileChangeRequest()
        changeRequest.displayName = displayName
        try await changeRequest.commitChanges()
        
        try await saveUserToFirestore(uid: user.uid, email: user.email!, displayName: displayName, photoURL: user.photoURL)
        return user
    }

    @discardableResult
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        let user = AuthDataResultModel(user: authDataResult.user)
        try await saveUserToFirestore(uid: user.uid, email: user.email!, displayName: user.displayName, photoURL: user.photoURL)
        return user
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func updatePassword(password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        try await user.updatePassword(to: password)
    }
    
    func updateEmail(email: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        try await user.sendEmailVerification(beforeUpdatingEmail: email)
    }
}


// MARK: SIGN IN SSO

extension AuthenticationManager {
    
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        let authDataResult = try await signIn(credential: credential)
        
        let user = User(uid: authDataResult.uid, email: tokens.email ?? "", displayName: tokens.name, photoURL: tokens.photoURL)
        print("Google sign-in user: \(user)")
        try await FirestoreManager.shared.saveUser(user: user)
        
        return authDataResult
    }
        
    func signInWithApple(tokens: SignInWithAppleResult) async throws -> AuthDataResultModel {
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokens.token, rawNonce: tokens.nonce)
        let authDataResult = try await signIn(credential: credential)
        
        let user = User(uid: authDataResult.uid, email: tokens.email ?? "", displayName: tokens.fullName, photoURL: nil)
        print("Apple sign-in user: \(user)")
        try await FirestoreManager.shared.saveUser(user: user)
        
        return authDataResult
    }

    private func signIn(credential: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
}
