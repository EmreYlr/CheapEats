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
    var selectedMealTypes: [MealType] { get set }
    var selectedMinMealPrice: Int { get set }
    var selectedDistance: Int { get set }
    func emptyCheckSelectedItem(filterVC: FilterViewController)
    func applyFilterItem(selectedMealTypes: [MealType], minMealPrice: Int, distance: Int)
    func filterProducts(by searchText: String)
}

protocol MoreViewModelOutputProtocol: AnyObject {
    func update()
    func error()
}

final class MoreViewModel {
    weak var delegate: MoreViewModelOutputProtocol?
    var products: [Product]? {
        didSet {
            filterProducts = products
            delegate?.update()
        }
    }
    private let priceThresholds = [0, 100, 150, 200]
    var filterProducts: [Product]? = []
    var selectedMealTypes: [MealType] = []
    var selectedMinMealPrice: Int = 0
    var selectedDistance: Int = 0
    
    func emptyCheckSelectedItem(filterVC: FilterViewController) {
        filterVC.filterViewModel.selectedMealTypes = selectedMealTypes
        if let index = priceThresholds.firstIndex(of: selectedMinMealPrice) {
            filterVC.filterViewModel.selectedMinMealPrice = index
        } else {
            filterVC.filterViewModel.selectedMinMealPrice = 0
        }
        filterVC.filterViewModel.selectedDistance = selectedDistance
    }
    
    func applyFilterItem(selectedMealTypes: [MealType], minMealPrice: Int, distance: Int) {
        self.selectedMealTypes = selectedMealTypes
        self.selectedMinMealPrice = priceThresholds[minMealPrice]
        self.selectedDistance = distance
        
        filterProducts = products?.filter { product in
            let matchesMealType = selectedMealTypes.isEmpty || product.mealType.contains(where: selectedMealTypes.contains)
            let productPrice = Int(product.newAmount.replacingOccurrences(of: "TL", with: "")) ?? 0
            let matchesPrice = selectedMinMealPrice == 0 || productPrice <= selectedMinMealPrice
            return matchesMealType && matchesPrice
        }
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
