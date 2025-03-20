//
//  CartViewController+TableView.swift
//  CheapEats
//
//  Created by Emre on 20.03.2025.
//

import UIKit

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return cartViewModel.cartItems.count
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartTableViewCell
        //let product = cartViewModel.cartItems[indexPath.row]
        //cell.configureCell(product: product)
        cell.fakeConfigure()
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}

