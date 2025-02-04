//
//  MoreViewModel.swift
//  CheapEats
//
//  Created by Emre on 29.11.2024.
//

import Foundation

protocol MoreViewModelProtocol {
    var delegate: MoreViewModelOutputProtocol? { get set }
    var productDetail: [ProductDetails]? { get set }
    var filterProducts: [ProductDetails]? { get set }
    var selectedMealTypes: [Category] { get set }
    var selectedMinMealPrice: Int { get set }
    var selectedDistance: Int { get set }
    func emptyCheckSelectedItem(filterVC: FilterViewController)
    func applyFilterItem(selectedMealTypes: [Category], minMealPrice: Int, distance: Int)
    func filterProducts(by searchText: String)
}

protocol MoreViewModelOutputProtocol: AnyObject {
    func update()
    func error()
}

final class MoreViewModel {
    weak var delegate: MoreViewModelOutputProtocol?
    var productDetail: [ProductDetails]? {
        didSet {
            filterProducts = productDetail
            delegate?.update()
        }
    }
    private let priceThresholds = [0, 100, 150, 200]
    var filterProducts: [ProductDetails]? = []
    var selectedMealTypes: [Category] = []
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
    
    func applyFilterItem(selectedMealTypes: [Category], minMealPrice: Int, distance: Int) {
        self.selectedMealTypes = selectedMealTypes
        self.selectedMinMealPrice = priceThresholds[minMealPrice]
        self.selectedDistance = distance
        
        filterProducts = productDetail?.filter { productDetails in
            let matchesMealType = selectedMealTypes.isEmpty || productDetails.product.category.contains(where: selectedMealTypes.contains)
            let productPrice = Int(productDetails.product.newPrice.replacingOccurrences(of: "TL", with: "")) ?? 0
            let matchesPrice = selectedMinMealPrice == 0 || productPrice <= selectedMinMealPrice
            return matchesMealType && matchesPrice
        }
        delegate?.update()
    }
    
    func filterProducts(by searchText: String) {
        if searchText.isEmpty {
            filterProducts = productDetail
        } else {
            filterProducts = productDetail?.filter { productDetails in
                productDetails.restaurant.name.localizedCaseInsensitiveContains(searchText) ||
                productDetails.product
                    .name.localizedCaseInsensitiveContains(searchText)
            }
        }
        delegate?.update()
    }

}

extension MoreViewModel: MoreViewModelProtocol { }
