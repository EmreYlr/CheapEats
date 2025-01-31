//
//  Orders.swift
//  CheapEats
//
//  Created by Emre on 14.12.2024.
//

import Foundation

struct Orders {
    let orderNumber: String
    let company: String
    let food: String
    let date: String
    let imageUrl: String
    let oldAmount: String
    let newAmount: String
    let orderStatus: OrderStatus
}

enum OrderStatus: String, CaseIterable, CustomStringConvertible {
    case preparing = "Hazırlanıyor"
    case delivered = "Teslim Edildi"
    case canceled = "İptal Edildi"
    
    var description: String {
        return self.rawValue
    }
}
/*
 struct Order {
     var orderId: String
     var userId: String
     var restaurantId: String
     var products: [[String: Any]]
     var totalPrice: Double
     var orderDate: Date
     var deliveryAddress: [String: String]
     var status: String
     var paymentMethod: String
 }
 
 import FirebaseFirestore

 // Belirli bir kullanıcıya ait siparişleri çekmek için fonksiyon
 func fetchOrdersForUser(userId: String, completion: @escaping ([Order]?, Error?) -> Void) {
     let db = Firestore.firestore()
     db.collection("orders").whereField("user_id", isEqualTo: userId).getDocuments { (querySnapshot, error) in
         if let error = error {
             completion(nil, error)
         } else {
             var orders = [Order]()
             for document in querySnapshot!.documents {
                 let data = document.data()
                 let order = Order(
                     orderId: document.documentID,
                     userId: data["user_id"] as? String ?? "",
                     restaurantId: data["restaurant_id"] as? String ?? "",
                     products: data["products"] as? [[String: Any]] ?? [],
                     totalPrice: data["total_price"] as? Double ?? 0.0,
                     orderDate: (data["order_date"] as? Timestamp)?.dateValue() ?? Date(),
                     deliveryAddress: data["delivery_address"] as? [String: String] ?? [:],
                     status: data["status"] as? String ?? "",
                     paymentMethod: data["payment_method"] as? String ?? ""
                 )
                 orders.append(order)
             }
             completion(orders, nil)
         }
     }
 }

 // Order model
 struct Order {
     var orderId: String
     var userId: String
     var restaurantId: String
     var products: [[String: Any]]
     var totalPrice: Double
     var orderDate: Date
     var deliveryAddress: [String: String]
     var status: String
     var paymentMethod: String
 }
 
 let userId = "kullanici_id" // Buraya çekmek istediğiniz kullanıcının ID'sini koyun

 fetchOrdersForUser(userId: userId) { orders, error in
     if let error = error {
         print("Error fetching orders: \(error)")
     } else if let orders = orders {
         for order in orders {
             print("Order ID: \(order.orderId), Total Price: \(order.totalPrice)")
         }
     }
 }
 */

/*
 import FirebaseFirestore

 // Siparişi orders koleksiyonuna eklemek için fonksiyon
 func addOrder(userId: String, restaurantId: String, products: [[String: Any]], totalPrice: Double, deliveryAddress: [String: String], paymentMethod: String, completion: @escaping (Error?) -> Void) {
     let db = Firestore.firestore()
     
     // Sipariş verisini hazırlama
     let orderData: [String: Any] = [
         "user_id": userId,
         "restaurant_id": restaurantId,
         "products": products,
         "total_price": totalPrice,
         "order_date": Timestamp(date: Date()),
         "delivery_address": deliveryAddress,
         "status": "Hazırlanıyor", // Örnek sipariş durumu
         "payment_method": paymentMethod
     ]
     
     // Yeni sipariş belgesini orders koleksiyonuna ekleme
     db.collection("orders").addDocument(data: orderData) { error in
         completion(error)
     }
 }

 // Product model örnekleri
 struct Product {
     var productId: String
     var name: String
     var price: Double
     var quantity: Int
 }

 // Kullanım Örneği
 let userId = "kullanici_id" // Kullanıcının ID'si
 let restaurantId = "restoran_id" // Restoranın ID'si

 // Sipariş edilen ürünlerin listesi
 let products: [[String: Any]] = [
     [
         "product_id": "urun_id_1",
         "name": "Ürün Adı 1",
         "price": 10.0,
         "quantity": 2
     ],
     [
         "product_id": "urun_id_2",
         "name": "Ürün Adı 2",
         "price": 20.0,
         "quantity": 1
     ]
 ]

 let totalPrice = 40.0 // Toplam fiyat
 let deliveryAddress = [
     "street": "Örnek Sokak",
     "city": "İstanbul",
     "state": "",
     "postal_code": "34000",
     "country": "Türkiye"
 ]
 let paymentMethod = "Kredi Kartı" // Ödeme yöntemi

 addOrder(userId: userId, restaurantId: restaurantId, products: products, totalPrice: totalPrice, deliveryAddress: deliveryAddress, paymentMethod: paymentMethod) { error in
     if let error = error {
         print("Error adding order: \(error)")
     } else {
         print("Order added successfully!")
     }
 }
 */
