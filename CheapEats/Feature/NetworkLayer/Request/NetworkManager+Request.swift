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
    func fetchProducts(completion: @escaping (Result<[Product], CustomError>) -> Void) {
        db.collection("products").whereField("status", isEqualTo: false).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion(.failure(.noData))
                return
            }
            
            let products = documents.compactMap { document -> Product? in
                Product(dictionary: document.data(), documentId: document.documentID)
            }
            
            if products.isEmpty {
                completion(.failure(.noData))
            } else {
                completion(.success(products))
            }
        }
    }
    
    func fetchRestaurant(completion: @escaping (Result<[Restaurant], CustomError>) -> Void) {
        db.collection("restaurants").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion(.failure(.noData))
                return
            }
            
            let restaurant = documents.compactMap { document -> Restaurant? in
                Restaurant(dictionary: document.data(), documentId: document.documentID)
            }
            
            if restaurant.isEmpty {
                completion(.failure(.noData))
            } else {
                completion(.success(restaurant))
            }
        }
    }
    
    func fetchOrders(completion: @escaping (Result<[UserOrder], CustomError>) -> Void) {
        let userId = UserManager.shared.user?.uid ?? "oiDMcITkunZm4MsJ4IpAB8mbwfz1"
        db.collection("orders").whereField("userId", isEqualTo: userId).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.failure(.noData))
                return
            }
            
            let orders = documents.compactMap { (document) -> UserOrder? in
                let data = document.data()
                return UserOrder(dictionary: data, documentId: document.documentID)
            }
            
            if orders.isEmpty {
                completion(.failure(.noData))
            } else {
                completion(.success(orders))
            }
            
            
        }
    }
    
    func fetchSelectedProduct(productIds: [String], completion: @escaping (Result<[Product], CustomError>) -> Void) {
        db.collection("products")
            .whereField(FieldPath.documentID(), in: productIds)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error getting documents: \(error)")
                    completion(.failure(.networkError(error)))
                } else {
                    var products: [Product] = []
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let productId = document.documentID
                        if let product = Product(dictionary: data, documentId: productId) {
                            products.append(product)
                        }
                    }
                    completion(.success(products))
                }
            }
    }
    
    func fetchUserCreditCards(completion: @escaping (Result<[UserCreditCards], CustomError>) -> Void) {
        let userId = UserManager.shared.user?.uid ?? "oiDMcITkunZm4MsJ4IpAB8mbwfz1"
        db.collection("userCreditCard").whereField("userId", isEqualTo: userId).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }

            guard let documents = snapshot?.documents else {
                completion(.failure(.noData))
                return
            }

            let creditCards = documents.compactMap { (document) -> UserCreditCards? in
                let data = document.data()
                return UserCreditCards(dictionary: data, documentId: document.documentID)
            }

            if creditCards.isEmpty {
                completion(.failure(.noData))
            } else {
                completion(.success(creditCards))
            }
        }
    }
    
    func deleteUserCreditCard(at cardId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let cardDocRef = Firestore.firestore().collection("userCreditCard").document(cardId)
        cardDocRef.delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func addUserCreditCard(card: UserCreditCards, completion: @escaping (Result<Void, Error>) -> Void) {
        let userCardRef = db.collection("userCreditCard").document()
        var userCardData = card
        userCardData.cardId = userCardRef.documentID
        
        userCardRef.setData(userCardData.toDictionary()) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
