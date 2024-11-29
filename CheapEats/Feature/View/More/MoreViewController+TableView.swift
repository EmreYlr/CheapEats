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
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let SB = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = SB.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
}
