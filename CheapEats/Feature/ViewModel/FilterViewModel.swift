//
//  FilterViewModel.swift
//  CheapEats
//
//  Created by Emre on 2.12.2024.
//

import Foundation

protocol FilterViewModelProtocol {
    var delegate: FilterViewModelOutputProtocol? { get set }
    var selectedMealTypes: [String] { get set }
    var selectedMinMealPrice: Int { get set }
    var selectedDistance: Int { get set }
    func emptyCheckSelectedItem(bottomSheetVC: BottomSheetViewController)
}

protocol FilterViewModelOutputProtocol: AnyObject {
    func didApplyFilter(selectedMealTypes: [String], minMealPrice: Int, distance: Int)
}

final class FilterViewModel {
    weak var delegate: FilterViewModelOutputProtocol?
    var selectedMealTypes: [String] = []
    var selectedMinMealPrice: Int = 0
    var selectedDistance: Int = 0

    func emptyCheckSelectedItem(bottomSheetVC: BottomSheetViewController) {
        if selectedMealTypes.isEmpty {
            bottomSheetVC.bottomSheetViewModel.selectedOptions = []
        } else {
            bottomSheetVC.bottomSheetViewModel.selectedOptions = selectedMealTypes
        }
    }
}

extension FilterViewModel: FilterViewModelProtocol {}

