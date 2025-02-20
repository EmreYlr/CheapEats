//
//  OrdersViewController.swift
//  CheapEats
//
//  Created by CANSU on 30.11.2024.
//

import Foundation
import UIKit

final class OrdersViewController: UIViewController {
    
    //MARK: -Variables
    @IBOutlet weak var ordersTableView: UITableView!
    var ordersViewModel: OrdersViewModelProtocol = OrdersViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        ordersViewModel.delegate = self
        print("OrdersViewController ")
        ordersViewModel.fetchData()
    }
    func initTableView() {
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
        ordersTableView.separatorStyle = .none
        ordersTableView.register(UINib(nibName: "OrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "ordersCell")
        ordersTableView.layer.cornerRadius = 10
        
    }
}

extension OrdersViewController: OrdersViewModelOutputProtocol {
    func update() {
        ordersViewModel.loadData()
        //print(ordersViewModel.orderDetailsList)
        print("update")
    }
    
    func error() {
        print("error")
    }
    
    func updateTable() {
        ordersTableView.reloadData()
    }
    
    
}
