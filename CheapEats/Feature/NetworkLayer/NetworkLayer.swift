//
//  NetworkLayer.swift
//  CheapEats
//
//  Created by Emre on 25.11.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    private let db = Firestore.firestore()
    
    
    func saveUserInfo(uid: String, userInfo: [String: Any]) {
        let db = Firestore.firestore()
        db.collection("users").document(uid).setData(userInfo) { error in
            if let error = error {
                print("Error saving user info: \(error)")
            } else {
                print("User info saved successfully!")
            }
        }
    }
    
    
    func registerUser(email: String, password: String, firstName: String, lastName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.main.async {
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let user = result?.user {
                    let userInfo: [String: Any] = [
                        "firstName": firstName,
                        "lastName": lastName,
                        "email": email,
                        "createdAt": Timestamp(date: Date())
                    ]
                    self.saveUserInfo(uid: user.uid, userInfo: userInfo)
                    completion(.success(()))
                } else if let error = error {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let authResult = authResult {
                completion(.success(authResult))
            }
        }
    }
    
    func signOutUser(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch let signOutError as NSError {
            completion(.failure(signOutError))
        }
    }
    
    func resetPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
}
