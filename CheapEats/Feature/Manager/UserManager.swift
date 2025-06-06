//
//  UserManager.swift
//  CheapEats
//
//  Created by Emre on 28.11.2024.
//

import Foundation

final class UserManager {
    static let shared = UserManager()
    private init() {}
    var user: Users?
    func signOut() {
        user = nil
    }
    func getUserId() -> String {
        return user?.uid ?? "oiDMcITkunZm4MsJ4IpAB8mbwfz1"
    }
}
