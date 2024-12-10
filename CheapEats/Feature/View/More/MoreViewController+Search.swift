//
//  MoreView+Search.swift
//  CheapEats
//
//  Created by Emre on 30.11.2024.
//

import Foundation
import UIKit

extension MoreViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        moreViewModel.filterProducts(by: searchText)
    }
}
