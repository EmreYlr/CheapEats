//
//  SuccessViewController.swift
//  CheapEats
//
//  Created by Emre on 2.06.2025.
//

import UIKit

final class SuccessViewController: UIViewController {
    //MARK: -Variables
    @IBOutlet weak var billImageView: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var ordersButton: UIButton!
    
    @IBOutlet weak var orderNoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var telNoLabel: UILabel!
    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!

    var successViewModel: SuccessViewModelProtocol = SuccessViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SuccessViewController")
        initLoad()
        setOrderDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = UIColor(named: "ButtonColor")
    }
    
    private func initLoad() {
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        locationButton.layer.cornerRadius = 8
        ordersButton.layer.cornerRadius = 8
        ordersButton.layer.borderColor = UIColor.button.cgColor
        ordersButton.layer.borderWidth = 1.5
        addHorizontalLine(toView: billImageView, belowView: dateLabel, horizontalPadding: 10)
        addHorizontalLine(toView: billImageView, belowView: telNoLabel, horizontalPadding: 10)
    }
    
    private func setOrderDetail() {
        guard let orderDetail = successViewModel.orderDetail else { return }
        
        orderNoLabel.text = "Order No: #\(orderDetail.userOrder.orderNo)"
        dateLabel.text = dateFormatter(with: orderDetail.userOrder.orderDate)
        restaurantNameLabel.text = orderDetail.productDetail.restaurant.companyName
        addressLabel.text = orderDetail.productDetail.restaurant.address
        telNoLabel.text = orderDetail.productDetail.restaurant.phone
        
        oldPriceLabel.text = "\(formatDouble(orderDetail.productDetail.product.oldPrice)) TL"
        discountLabel.text = "\(formatDouble(orderDetail.productDetail.product.newPrice - orderDetail.productDetail.product.oldPrice)) TL"
        totalLabel.text = "\(formatDouble(orderDetail.productDetail.product.newPrice)) TL"
    }
    
    @IBAction func locationButtonClicked(_ sender: UIButton) {
    }
    
    @IBAction func ordersButtonClicked(_ sender: UIButton) {
    }
}
