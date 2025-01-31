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
    func fetchProducts(completion: @escaping ([Product]?, Error?) -> Void) {
        db.collection("products").getDocuments(source: .default) { (querySnapshot, error) in
            if let error = error {
                completion(nil, error)
            } else {
                var products = [Product]()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let categoryStrings = data["category"] as? [String] ?? []
                    let categories = categoryStrings.compactMap { Category(rawValue: $0) }
                    
                    let deliveryTypeString = data["deliveryType"] as? String ?? DeliveryType.all.rawValue
                    let deliveryType = DeliveryType(rawValue: deliveryTypeString) ?? .all
                    
                    let product = Product(
                        productId: document.documentID,
                        name: data["name"] as? String ?? "",
                        description: data["description"] as? String ?? "",
                        oldPrice: data["oldPrice"] as? String ?? "",
                        newPrice: data["newPrice"] as? String ?? "",
                        restaurantId: data["restaurantId"] as? String ?? "",
                        restaurantName: data["restaurantName"] as? String ?? "",
                        category: categories,
                        imageUrl: data["imageUrl"] as? String ?? "",
                        deliveryType: deliveryType,
                        createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date(),
                        endDate: data["endDate"] as? String ?? "00:00"
                    )
                    products.append(product)
                }
                completion(products, nil)
            }
        }
    }
}
