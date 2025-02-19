//
//  OrdersDetailViewController.swift
//  CheapEats
//
//  Created by CANSU on 1.12.2024.
//

import Foundation
import UIKit
final class OrderDetailViewController: UIViewController{
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
    
    var orderDetailViewModel: OrderDetailViewModelProtocol = OrderDetailViewModel()
    
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
        
        /*if let order = orderDetailViewModel.order {
            detailImageView.image = UIImage(named: order.imageUrl)
            companyLabel.text = "Restorant Adı: \(order.company)"
            foodLabel.text = "Yemek: \(order.food)"
            dateLabel.text = "Tarih: \(order.date)"
            orderNo.text = "Sipariş No: #\(order.orderNumber)"
            let oldAmount = Int(order.oldAmount) ?? 0
            let newAmount = Int(order.newAmount) ?? 0
            oldholdsLbl.text = "\(order.oldAmount) TL"
            discountLbl.text = "\(oldAmount - newAmount) TL"
            newAmountLbl.text = "\(order.newAmount) TL"
            totalLbl.text = "\(order.newAmount) TL"
        }*/
    }
    
    
}

extension OrderDetailViewController: OrderDetailViewModelOutputProtocol {
    func update() {
        print("update")
    }
    
    func error() {
        print("error")
    }
    
    
}
