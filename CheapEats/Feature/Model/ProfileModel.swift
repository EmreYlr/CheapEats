//
//  ProfileModel.swift
//  CheapEats
//
//  Created by CANSU on 3.12.2024.
//

import Foundation
struct ProfileModel {
    let phone: String
    let email: String
    let photo: String
    let personName: String
    
    init?(dictionary: [String: Any]) {
        guard
            let phone = dictionary["phone"] as? String,
            let email = dictionary["email"] as? String,
            let photo = dictionary["photo"] as? String,
            let personName = dictionary["personName"] as? String
        else {
            return nil
        }
        
        self.phone = phone
        self.email = email
        self.photo = photo
        self.personName = personName
    }
}
