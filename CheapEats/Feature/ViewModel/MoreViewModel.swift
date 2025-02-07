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
    var selectedDistance: Double { get set }
    func emptyCheckSelectedItem(filterVC: FilterViewController)
    func applyFilterItem(selectedMealTypes: [Category], minMealPrice: Int, distance: Int)
    func distanceProductFilter(with filterProductDetails: [ProductDetails])
    func filterProducts(by searchText: String)
}

protocol MoreViewModelOutputProtocol: AnyObject {
    func update()
    func error()
    func startLoading()
    func stopLoading()
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
    private let distanceThresholds = [0.0, 0.5, 1.0, 2.0]
    var filterProducts: [ProductDetails]? = []
    var selectedMealTypes: [Category] = []
    var selectedMinMealPrice: Int = 0
    var selectedDistance: Double = 0
    
    func emptyCheckSelectedItem(filterVC: FilterViewController) {
        filterVC.filterViewModel.selectedMealTypes = selectedMealTypes
        if let index = priceThresholds.firstIndex(of: selectedMinMealPrice) {
            filterVC.filterViewModel.selectedMinMealPrice = index
        } else {
            filterVC.filterViewModel.selectedMinMealPrice = 0
        }
        if let index = distanceThresholds.firstIndex(of: selectedDistance) {
            filterVC.filterViewModel.selectedDistance = index
        } else {
            filterVC.filterViewModel.selectedDistance = 0
        }
    }
    
    func applyFilterItem(selectedMealTypes: [Category], minMealPrice: Int, distance: Int) {
        self.selectedMealTypes = selectedMealTypes
        self.selectedMinMealPrice = priceThresholds[minMealPrice]
        self.selectedDistance = distanceThresholds[distance]
        
        filterProducts = productDetail?.filter { productDetails in
            let matchesMealType = selectedMealTypes.isEmpty || productDetails.product.category.contains(where: selectedMealTypes.contains)
            let productPrice = Int(productDetails.product.newPrice.replacingOccurrences(of: "TL", with: "")) ?? 0
            let matchesPrice = selectedMinMealPrice == 0 || productPrice <= selectedMinMealPrice
            return matchesMealType && matchesPrice
        }
        if let filterProducts = filterProducts {
            distanceProductFilter(with: filterProducts)
        }
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
    
    func distanceProductFilter(with filterProductDetails: [ProductDetails]) {
        if selectedDistance == 0 {
            filterProducts = filterProductDetails
            delegate?.update()
            return
        }
        self.delegate?.startLoading()
        distanceCalculate(with: filterProductDetails) { [weak self] result in
            self?.filterProducts = result
                .filter { $0.1 <= self?.selectedDistance ?? 0 }
                .map { $0.0 }
            self?.delegate?.stopLoading()
            self?.delegate?.update()
        }
    }
    
    private func distanceCalculate(with productDetails: [ProductDetails], completion: @escaping ([(ProductDetails, Double)]) -> Void) {
        let group = DispatchGroup()
        var results: [(ProductDetails, Double)] = []
        if let userLat = LocationManager.shared.currentLatitude,
        let userLon = LocationManager.shared.currentLongitude {
            for detail in productDetails {
                group.enter()
                getRouteDistance(userLat: userLat, userLon: userLon, destLat: detail.restaurant.location.latitude, destLon: detail.restaurant.location.longitude) { distance in
                    results.append((detail, distance))
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) {
            completion(results)
        }
    }

}

extension MoreViewModel: MoreViewModelProtocol { }
