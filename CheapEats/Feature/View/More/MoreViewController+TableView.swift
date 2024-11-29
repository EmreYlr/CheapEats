//
//  MoreViewController+TableView.swift
//  CheapEats
//
//  Created by Emre on 29.11.2024.
//

import Foundation
import UIKit

extension MoreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodcell", for: indexPath) as! FoodTableViewCell
        cell.foodImageView.image = UIImage(named: "testImage")
        cell.foodImageView.layer.opacity = 0.8
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    
}
