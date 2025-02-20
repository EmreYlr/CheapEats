//
//  OrdersViewController+TableView.swift
//  CheapEats
//
//  Created by CANSU on 30.11.2024.
//

import Foundation
import UIKit
extension OrdersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordersViewModel.orderDetailsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ordersCell", for: indexPath) as! OrdersTableViewCell
        cell.configureCell(with: ordersViewModel.orderDetailsList[indexPath.row])
        cell.selectionStyle = .none
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let SB = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = SB.instantiateViewController(withIdentifier: "OrdersDetailViewController") as! OrderDetailViewController
        detailVC.orderDetailViewModel.order = ordersViewModel.orderDetailsList[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
        }

