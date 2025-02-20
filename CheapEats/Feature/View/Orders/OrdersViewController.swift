//
//  OrdersViewController.swift
//  CheapEats
//
//  Created by CANSU on 30.11.2024.
//

import Foundation
import UIKit
import NVActivityIndicatorView

final class OrdersViewController: UIViewController {
    
    //MARK: -Variables
    @IBOutlet weak var ordersTableView: UITableView!
    @IBOutlet weak var waitView: UIView!
    private var loadIndicator: NVActivityIndicatorView!
    
    var ordersViewModel: OrdersViewModelProtocol = OrdersViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        setupLoadingIndicator()
        ordersViewModel.delegate = self
        print("OrdersViewController")
        ordersViewModel.fetchData()
    }
    
    func initTableView() {
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
        ordersTableView.separatorStyle = .none
        ordersTableView.register(UINib(nibName: "OrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "ordersCell")
        ordersTableView.layer.cornerRadius = 10
    }
    
    private func setupLoadingIndicator() {
        loadIndicator = createLoadingIndicator(in: waitView)
    }
}

extension OrdersViewController: OrdersViewModelOutputProtocol {
    func update() {
        ordersViewModel.loadData()
        print("update")
    }
    
    func error() {
        print("error")
    }
    
    func updateTable() {
        ordersTableView.reloadData()
    }
    
    func startLoading() {
        waitView.isHidden = false
        loadIndicator.isHidden = false
        loadIndicator.startAnimating()
    }
    
    func stopLoading() {
        waitView.isHidden = true
        loadIndicator.isHidden = true
        loadIndicator.stopAnimating()
    }
    
    
}
