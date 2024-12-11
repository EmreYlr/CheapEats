//
//  HomeViewModel.swift
//  CheapEats
//
//  Created by Emre on 24.11.2024.
//

import Foundation

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelOutputProtocol? { get set }
    var user: Users? { get set }
    var endlingProduct: [Product]? { get set }
    var recommendedProduct: [Product]? { get set }
}

protocol HomeViewModelOutputProtocol: AnyObject{
    func update()
    func error()
}

final class HomeViewModel {
    weak var delegate: HomeViewModelOutputProtocol?
    var user: Users?
    var endlingProduct: [Product]? = [Product(company: "McDonalds", food: "BigMac", date: "12.12.2024", oldAmount: "150TL", newAmount: "100TL", imageUrl: "testImage", mealType: [.burger]), Product(company: "BurgerKing", food: "Whopper", date: "12.12.2024", oldAmount: "200TL", newAmount: "150TL", imageUrl: "testImage2", mealType: [.burger]), Product(company: "KFC", food: "Bucket", date: "12.12.2024", oldAmount: "300TL", newAmount: "250TL", imageUrl: "testImage3", mealType: [.tavuk]), Product(company: "Popeyes", food: "Chicken", date: "12.12.2024", oldAmount: "100TL", newAmount: "50TL", imageUrl: "testImage4", mealType: [.tavuk])]
    var recommendedProduct: [Product]? = [Product(company: "KFC", food: "Bucket", date: "12.12.2024", oldAmount: "300TL", newAmount: "250TL", imageUrl: "testImage3", mealType: [.tavuk]) ,Product(company: "Popeyes", food: "Chicken", date: "12.12.2024", oldAmount: "100TL", newAmount: "50TL", imageUrl: "testImage4", mealType: [.tavuk]), Product(company: "McDonalds", food: "BigMac", date: "12.12.2024", oldAmount: "150TL", newAmount: "100TL", imageUrl: "testImage", mealType: [.burger]), Product(company: "BurgerKing", food: "Whopper", date: "12.12.2024", oldAmount: "200TL", newAmount: "150TL", imageUrl: "testImage2", mealType: [.burger])]
    init() {
        self.user = UserManager.shared.user
    }
}

extension HomeViewModel: HomeViewModelProtocol { }
