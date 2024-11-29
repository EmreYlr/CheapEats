//
//  MoreViewController.swift
//  CheapEats
//
//  Created by Emre on 29.11.2024.
//

import UIKit

final class MoreViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        print("More")
    }
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FoodTableViewCell", bundle: nil), forCellReuseIdentifier: "foodcell")
        tableView.layer.cornerRadius = 10
        
    }
}
