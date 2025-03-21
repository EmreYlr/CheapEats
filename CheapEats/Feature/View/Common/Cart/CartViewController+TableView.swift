//
//  CartViewController+TableView.swift
//  CheapEats
//
//  Created by Emre on 20.03.2025.
//

import UIKit

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartViewModel.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartTableViewCell
        let product = cartViewModel.cartItems[indexPath.row]
        cell.configureCell(product: product)
        
        cell.callback = { [weak self] count in
            self?.cartViewModel.updateCount(product: product, count: count)
        }
        
        cell.deleteCallback = { [weak self] in
            guard let self = self else { return }
            self.animationDelete(product: product)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    private func animationDelete(product: ProductDetails) {
        if let index = self.cartViewModel.cartItems.firstIndex(where: { $0.product.productId == product.product.productId }) {
            
            let indexPath = IndexPath(row: index, section: 0)
            let isLastItem = self.cartViewModel.cartItems.count == 1
            
            self.cartViewModel.deleteProduct(product: product)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.endUpdates()
            
            if isLastItem {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
        
    }
}

