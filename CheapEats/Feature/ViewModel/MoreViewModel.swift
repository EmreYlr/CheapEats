//
//  MoreViewModel.swift
//  CheapEats
//
//  Created by Emre on 29.11.2024.
//

import Foundation

protocol MoreViewModelProtocol {
    var delegate: MoreViewModelOutputProtocol? { get set }
    var products: [Product]? { get set }
    var filterProducts: [Product]? { get set }
    var selectedMealTypes: [String] { get set }
    var selectedMinMealPrice: Int { get set }
    var selectedDistance: Int { get set }
    func emptyCheckSelectedItem(filterVC: FilterViewController)
    func applyFilterItem(selectedMealTypes: [String], minMealPrice: Int, distance: Int)
    func filterProducts(by searchText: String)
}

protocol MoreViewModelOutputProtocol: AnyObject {
    func update()
    func error()
}

final class MoreViewModel {
    weak var delegate: MoreViewModelOutputProtocol?
    var products: [Product]? = [Product(company: "McDonalds", food: "BigMac", date: "12.12.2024", oldAmount: "150TL", newAmount: "100TL", imageUrl: "testImage"), Product(company: "BurgerKing", food: "Whopper", date: "12.12.2024", oldAmount: "200TL", newAmount: "150TL", imageUrl: "testImage2"), Product(company: "KFC", food: "Bucket", date: "12.12.2024", oldAmount: "300TL", newAmount: "250TL", imageUrl: "testImage3"), Product(company: "Popeyes", food: "Chicken", date: "12.12.2024", oldAmount: "100TL", newAmount: "50TL", imageUrl: "testImage4")]
    var filterProducts: [Product]? = []
    var selectedMealTypes: [String] = []
    var selectedMinMealPrice: Int = 0
    var selectedDistance: Int = 0
    init() {
        filterProducts = products
    }
    
    func emptyCheckSelectedItem(filterVC: FilterViewController) {
        filterVC.filterViewModel.selectedMealTypes = selectedMealTypes
        filterVC.filterViewModel.selectedMinMealPrice = selectedMinMealPrice
        filterVC.filterViewModel.selectedDistance = selectedDistance
    }
    
    func applyFilterItem(selectedMealTypes: [String], minMealPrice: Int, distance: Int) {
        self.selectedMealTypes = selectedMealTypes
        self.selectedMinMealPrice = minMealPrice
        self.selectedDistance = distance
        delegate?.update()
    }
    
    func filterProducts(by searchText: String) {
        if searchText.isEmpty {
            filterProducts = products
        } else {
            filterProducts = products?.filter { product in
                product.company.localizedCaseInsensitiveContains(searchText) ||
                product.food.localizedCaseInsensitiveContains(searchText)
            }
        }
        delegate?.update()
    }

}

extension MoreViewModel: MoreViewModelProtocol { }
