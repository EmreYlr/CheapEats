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
    func emptyCheckSelectedItem(bottomSheetVC: BottomSheetViewController)
    func applyFilter()
}

protocol FilterViewModelOutputProtocol: AnyObject {
    func didApplyFilter()
}

final class FilterViewModel {
    var selectedMealTypes: [String] = []
    weak var delegate: FilterViewModelOutputProtocol?
    
    func emptyCheckSelectedItem(bottomSheetVC: BottomSheetViewController) {
        if selectedMealTypes.isEmpty {
            bottomSheetVC.bottomSheetViewModel.selectedOptions = []
        } else {
            bottomSheetVC.bottomSheetViewModel.selectedOptions = selectedMealTypes
        }
    }
    
    func applyFilter() {
        delegate?.didApplyFilter()
    }
}

extension FilterViewModel: FilterViewModelProtocol {}

