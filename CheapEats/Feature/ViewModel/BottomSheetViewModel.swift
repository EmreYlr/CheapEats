//
//  BottomSheetViewModel.swift
//  CheapEats
//
//  Created by Emre on 2.12.2024.
//

import Foundation
import UIKit

protocol BottomSheetViewModelProtocol {
    var delegate: BottomSheetViewModelOutputProtocol? { get set}
    var options: [String] { get }
    var selectedOptions: [String] { get set }
    func clearSelection(tableView: UITableView)
}

protocol BottomSheetViewModelOutputProtocol: AnyObject {
    func didChangeSelection()
}

protocol BottomSheetViewModelDelegate: AnyObject {
    func didApplySelection(selectedOptions: [String])
}

final class BottomSheetViewModel {
    var options = ["Burger", "Döner", "Tatlı", "Pizza", "Tavuk", "Köfte", "Ev Yemekleri", "Pastane & Fırın", "Kebap", "Kahvaltı", "Vegan", "Çorba"]
    var selectedOptions: [String] = []
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
