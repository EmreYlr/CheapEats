//
//  NetworkManager+Request.swift
//  CheapEats
//
//  Created by Emre on 31.01.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


extension NetworkManager {
    //MARK: - UserRequest
    func registerUser(email: String, password: String, firstName: String, lastName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.main.async {
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let user = result?.user {
                    let userInfo: [String: Any] = [
                        "uid": user.uid,
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
    
    func getUserInfo(uid: String, completion: @escaping (Users?) -> Void) {
        let userRef = db.collection("users").document(uid)
        userRef.getDocument { document, _ in
            guard let document = document, document.exists, let data = document.data(), let user = Users(data: data) else {
                completion(nil)
                return
            }
            UserManager.shared.user = user
            completion(user)
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
    
    //MARK: -ProductRequest
    func fetchProducts(completion: @escaping (Result<[Product], ProductError>) -> Void) {
        db.collection("products").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let products = try documents.compactMap { document -> Product? in
                    try Product(dictionary: document.data(), documentId: document.documentID)
                }
                
                if products.isEmpty {
                    completion(.failure(.noData))
                } else {
                    completion(.success(products))
                }
            } catch let error as ProductError {
                completion(.failure(error))
            } catch {
                completion(.failure(.decodingError))
            }
        }
    }
}
