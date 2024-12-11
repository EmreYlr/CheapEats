//
//  BottomSheetViewModel.swift
//  CheapEats
//
//  Created by Emre on 2.12.2024.
//

import Foundation
import UIKit

protocol BottomSheetViewModelProtocol {
    var delegate: BottomSheetViewModelOutputProtocol? { get set }
    var options: [MealType] { get }
    var selectedOptions: [MealType] { get set }
    func clearSelection(tableView: UITableView)
}

protocol BottomSheetViewModelOutputProtocol: AnyObject {
    func didChangeSelection()
}

protocol BottomSheetViewModelDelegate: AnyObject {
    func didApplySelection(selectedOptions: [MealType])
}

final class BottomSheetViewModel {
    var options = MealType.allCases
    var selectedOptions: [MealType] = []
    weak var delegate: BottomSheetViewModelOutputProtocol?

    func clearSelection(tableView: UITableView) {
        selectedOptions.removeAll()
        if let selectedRows = tableView.indexPathsForSelectedRows {
            for indexPath in selectedRows {
                tableView.deselectRow(at: indexPath, animated: false)
            }
        }
        delegate?.didChangeSelection()
    }
}
extension BottomSheetViewModel: BottomSheetViewModelProtocol {}
