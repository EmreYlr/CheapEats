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
    @IBOutlet weak var orderNumberLbl: UILabel!
    @IBOutlet weak var paymentDetailView: UIView!
    @IBOutlet weak var oldholdsLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var newAmountLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var orderNo: UILabel!
    
    private let orderDetailViewModel: OrdersDetailViewModelProtocol = OrdersDetailViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("OrdersDetailViewController ")
        initScreen()
        
    }
    
    private func initScreen() {
        orderNumberLbl.roundCorners(corners: [.topRight, .bottomRight], radius: 10, borderColor: UIColor(named: "BG"), borderWidth: 2)
        orderNo.roundCorners(corners: [.topLeft, .bottomLeft], radius: 10, borderColor: UIColor(named: "BG"), borderWidth: 2)
        detailImageView.roundCorners(corners: [.allCorners], radius: 10, borderColor: UIColor(named: "ButtonColor"), borderWidth: 2)
        paymentDetailView.roundCorners(corners: [.allCorners], radius: 10, borderColor: UIColor(named: "ButtonColor"), borderWidth: 2)
        orderDetailView.roundCorners(corners: [.allCorners], radius: 10, borderColor: UIColor(named: "ButtonColor"), borderWidth: 2)
    }

}

extension OrdersDetailViewController: OrdersDetailViewModelOutputProtocol {
    func update() {
        print("update")
    }
    
    func error() {
        print("error")
    }
    
    
}
