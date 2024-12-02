//
//  MoreViewModel.swift
//  CheapEats
//
//  Created by Emre on 29.11.2024.
//

import Foundation

protocol MoreViewModelProtocol {
    var delegate: MoreViewModelOutputProtocol? { get set }
    var selectedMealTypes: [String] { get set }
    var selectedMinMealPrice: Int { get set }
    var selectedDistance: Int { get set }
    func emptyCheckSelectedItem(filterVC: FilterViewController)
    func applyFilterItem(selectedMealTypes: [String], minMealPrice: Int, distance: Int)
}

protocol MoreViewModelOutputProtocol: AnyObject {
    func update()
    func error()
}


final class MoreViewModel {
    weak var delegate: MoreViewModelOutputProtocol?
    var selectedMealTypes: [String] = []
    var selectedMinMealPrice: Int = 0
    var selectedDistance: Int = 0
    
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
}

extension MoreViewModel: MoreViewModelProtocol { }
