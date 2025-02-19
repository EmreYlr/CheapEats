//
//  User.swift
//  CheapEats
//
//  Created by Emre on 28.11.2024.
//

import Foundation
import FirebaseFirestore

struct Users {
    let uid: String
    let firstName: String
    let lastName: String
    let email: String
    let createdAt: Date
    
    init?(data: [String: Any]) {
        guard let firstName = data["firstName"] as? String,
              let lastName = data["lastName"] as? String,
              let email = data["email"] as? String,
              let uid = data["uid"] as? String,
              let timestamp = data["createdAt"] as? Timestamp else {
            return nil
        }
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.createdAt = timestamp.dateValue()
    }
}
