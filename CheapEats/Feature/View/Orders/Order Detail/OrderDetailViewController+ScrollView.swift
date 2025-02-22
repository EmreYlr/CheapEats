//
//  OrderDetailViewController+ScrollView.swift
//  CheapEats
//
//  Created by Emre on 22.02.2025.
//
import UIKit

extension OrderDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY > 0 {
            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.backgroundColor = .white
            navigationController?.navigationBar.tintColor = .white
        } else {
            navigationController?.navigationBar.backgroundColor = .clear
            navigationController?.navigationBar.tintColor = UIColor(named: "ButtonColor")
        }
    }
}
