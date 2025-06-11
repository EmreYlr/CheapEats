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
    func registerUser(email: String, telNo: String, password: String, firstName: String, lastName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.main.async {
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let user = result?.user {
                    let userInfo: [String: Any] = [
                        "uid": user.uid,
                        "firstName": firstName,
                        "lastName": lastName,
                        "email": email,
                        "phoneNumber": telNo,
                        "updateAt": Timestamp(date: Date()),
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
    
    func updateUserInfo(user: Users, completion: @escaping (Result<Void, Error>) -> Void) {
        let userId = Auth.auth().currentUser?.uid ?? ""
        let userRef = db.collection("users").document(userId)
        let updates: [String: Any] = [
            "firstName": user.firstName,
            "lastName": user.lastName,
            "email": user.email,
            "phoneNumber": user.phoneNumber,
            "updatedAt": Timestamp(date: Date())
        ]
        userRef.updateData(updates) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                UserManager.shared.user = user
                completion(.success(()))
            }
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
    func updatePassword(currentPassword: String, newPassword: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser,
              let email = currentUser.email else {
            return
        }
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        currentUser.reauthenticate(with: credential) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            currentUser.updatePassword(to: newPassword) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
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
        let userId = UserManager.shared.getUserId()
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
        let userId = UserManager.shared.getUserId()
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
    
    func addUserCreditCard(card: UserCreditCards, completion: @escaping (Result<String, Error>) -> Void) {
        let userCardRef = db.collection("userCreditCard").document()
        var userCardData = card
        userCardData.cardId = userCardRef.documentID
        
        userCardRef.setData(userCardData.toDictionary()) {error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(userCardRef.documentID))
            }
        }
    }
    
    //MARK: -Coupon
    func fetchCoupon(byCode code: String, completion: @escaping (Result<Coupon, Error>) -> Void) {
        db.collection("coupon")
            .whereField("code", isEqualTo: code)
            .limit(to: 1)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let document = snapshot?.documents.first else {
                    let notFoundError = NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Kupon bulunamadı."])
                    completion(.failure(notFoundError))
                    return
                }
                
                if let coupon = Coupon(dictionary: document.data(), documentId: document.documentID) {
                    completion(.success(coupon))
                } else {
                    let parseError = NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Kupon verisi parse edilemedi."])
                    completion(.failure(parseError))
                }
            }
    }
    
    func fetchCouponById(id: String, completion: @escaping (Result<Coupon, Error>) -> Void) {
        db.collection("coupon").document(id).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists, let data = document.data() else {
                let notFoundError = NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Kupon bulunamadı."])
                completion(.failure(notFoundError))
                return
            }
            
            if let coupon = Coupon(dictionary: data, documentId: document.documentID) {
                completion(.success(coupon))
            } else {
                let parseError = NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Kupon verisi parse edilemedi."])
                completion(.failure(parseError))
            }
        }
    }
    
    
    //MARK: -Order
    func addOrder(order: UserOrder, completion: @escaping (Result<String, Error>) -> Void) {
        let orderRef = db.collection("orders").document()
        let orderNo = String(Int.random(in: 100000...999999))
        var newOrder = order
        
        newOrder.orderId = orderRef.documentID
        newOrder.orderNo = orderNo
        
        setDescreaseQuantity(productId: order.productId, selectedCount: order.quantity) { result in
            switch result {
            case .success:
                orderRef.setData(newOrder.toDictionary()) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(orderNo))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func setDescreaseQuantity(productId: String, selectedCount: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let productRef = db.collection("products").document(productId)
        
        productRef.getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = snapshot?.data(),
                  let currentQuantity = data["quantity"] as? Int else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Quantity not found"])))
                return
            }
            
            let newQuantity = currentQuantity - selectedCount
            if newQuantity < 0 {
                completion(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Not enough stock"])))
                return
            }
            
            var updateData: [String: Any] = ["quantity": newQuantity]
            if newQuantity == 0 {
                updateData["status"] = true
            }
            
            productRef.updateData(updateData) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
    
    func listenOrderStatus(onStatusChanged: @escaping (UserOrder) -> Void) -> ListenerRegistration? {
        let userId = UserManager.shared.getUserId()
        
        let listener = db.collection("orders")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Order status dinlenirken hata oluştu: \(error.localizedDescription)")
                    return
                }
                
                guard let snapshot = snapshot else { return }
                
                for diff in snapshot.documentChanges {
                    if diff.type == .modified {
                        if let changedOrder = UserOrder(dictionary: diff.document.data(), documentId: diff.document.documentID) {
                            onStatusChanged(changedOrder)
                        }
                    }
                }
            }
        return listener
    }
    
}
