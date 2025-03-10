//
//  UserDefaultsKeys.swift
//  CheapEats
//
//  Created by Emre on 10.03.2025.
//
import Foundation

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    // MARK: - Keys
    struct Keys {
        static let isUserLoggedIn = "isUserLoggedIn"
        static let currentUser = "currentUser"
    }
    
    // MARK: - User Methods
    func saveUser(_ user: Users) {
        do {
            let encoder = JSONEncoder()
            let userData = try encoder.encode(user)
            UserDefaults.standard.set(userData, forKey: Keys.currentUser)
            UserDefaults.standard.set(true, forKey: Keys.isUserLoggedIn)
        } catch {
            print("Error encoding user: \(error.localizedDescription)")
        }
    }
    
    func getUser() -> Users? {
        guard let userData = UserDefaults.standard.data(forKey: Keys.currentUser) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(Users.self, from: userData)
            return user
        } catch {
            print("Error decoding user: \(error.localizedDescription)")
            return nil
        }
    }
    
    func isUserLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: Keys.isUserLoggedIn)
    }
    
    func clearUserData() {
        UserDefaults.standard.removeObject(forKey: Keys.currentUser)
        UserDefaults.standard.removeObject(forKey: Keys.isUserLoggedIn)
    }
}
