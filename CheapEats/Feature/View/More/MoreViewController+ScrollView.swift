//
//  MoreViewController+ScrollView.swift
//  CheapEats
//
//  Created by Emre on 2.12.2024.
//

import Foundation
import UIKit

extension MoreViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY > 0 {
            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.backgroundColor = .white
            navigationController?.navigationBar.tintColor = .white
            filterButton.tintColor = .white
        } else {
            navigationController?.navigationBar.backgroundColor = .clear
            navigationController?.navigationBar.tintColor = UIColor(named: "ButtonColor")
            filterButton.tintColor = UIColor(named: "ButtonColor")
        }
    }
}
