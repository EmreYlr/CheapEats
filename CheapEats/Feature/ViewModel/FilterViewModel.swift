//
//  FilterViewModel.swift
//  CheapEats
//
//  Created by Emre on 2.12.2024.
//

import Foundation

protocol FilterViewModelProtocol {
    var delegate: FilterViewModelOutputProtocol? { get set }
    var selectedMealTypes: [MealType] { get set }
    var selectedMinMealPrice: Int { get set }
    var selectedDistance: Int { get set }
    func clearFilters()
    func emptyCheckSelectedItem(bottomSheetVC: BottomSheetViewController)
}

protocol FilterViewModelOutputProtocol: AnyObject {
    func didApplyFilter(selectedMealTypes: [MealType], minMealPrice: Int, distance: Int)
}

final class FilterViewModel {
    weak var delegate: FilterViewModelOutputProtocol?
    var selectedMealTypes: [MealType] = []
    var selectedMinMealPrice: Int = 0
    var selectedDistance: Int = 0

    func emptyCheckSelectedItem(bottomSheetVC: BottomSheetViewController) {
        if selectedMealTypes.isEmpty {
            bottomSheetVC.bottomSheetViewModel.selectedOptions = []
        } else {
            bottomSheetVC.bottomSheetViewModel.selectedOptions = selectedMealTypes
        }
    }

    func clearFilters() {
        selectedMealTypes = []
        selectedMinMealPrice = 0
        selectedDistance = 0
    }
}

extension FilterViewModel: FilterViewModelProtocol {}

