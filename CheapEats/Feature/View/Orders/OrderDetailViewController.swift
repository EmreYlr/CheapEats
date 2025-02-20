//
//  OrdersDetailViewController.swift
//  CheapEats
//
//  Created by CANSU on 1.12.2024.
//

import Foundation
import UIKit
import Kingfisher

final class OrderDetailViewController: UIViewController{
    //MARK: -Variables
    @IBOutlet weak var orderDetailView: UIView!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var paymentDetailView: UIView!
    @IBOutlet weak var oldAmountLbl: UILabel!
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
        
        if let order = orderDetailViewModel.order {
            detailImageView.kf.indicatorType = .activity
            detailImageView.kf.setImage(with: URL(string: order.productDetail.product.imageUrl))
            companyLabel.text = "Restorant Adı: \(order.productDetail.restaurant.name)"
            foodLabel.text = "Yemek: \(order.productDetail.product.name)"
            dateLabel.text = "Tarih: \(dateFormatter(with: order.userOrder.orderDate))"
            orderNo.text = "Sipariş No: #\(order.userOrder.orderNo)"
            let oldAmount = Double(order.productDetail.product.oldPrice)
            let newAmount = Double(order.productDetail.product.newPrice)
            oldAmountLbl.text = "\(formatDouble(order.productDetail.product.oldPrice)) TL"
            discountLbl.text = "\(formatDouble(oldAmount - newAmount)) TL"
            newAmountLbl.text = "\(formatDouble(order.productDetail.product.newPrice)) TL"
            totalLbl.text = "\(formatDouble(newAmount)) TL"
        }
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
