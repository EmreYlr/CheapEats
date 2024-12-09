//
//  OrdersDetailViewController.swift
//  CheapEats
//
//  Created by CANSU on 1.12.2024.
//

import Foundation
import UIKit
final class OrdersDetailViewController: UIViewController{
    //MARK: -Variables
    @IBOutlet weak var orderDetailView: UIView!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var paymentDetailView: UIView!
    @IBOutlet weak var oldholdsLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var newAmountLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var orderNo: UILabel!
    
    private let orderDetailViewModel: OrdersViewModelProtocol = OrdersViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("OrdersDetailViewController ")
        initScreen()
        
    }
    private func initScreen() {
        configureView(orderNo, cornerRadius: 10, borderColor: UIColor(named: "BG"), borderWidth: 1)
        configureView(detailImageView, cornerRadius: 10, borderColor: UIColor(named: "ButtonColor"), borderWidth: 1)
        configureView(paymentDetailView, cornerRadius: 10, borderColor: UIColor(named: "ButtonColor"), borderWidth: 1)
        configureView(orderDetailView, cornerRadius: 10, borderColor: UIColor(named: "ButtonColor"), borderWidth: 1)
    }
    
    
}

extension OrdersDetailViewController: OrdersViewModelOutputProtocol {
    func update() {
        print("update")
    }
    
    func error() {
        print("error")
    }
    
    
}
