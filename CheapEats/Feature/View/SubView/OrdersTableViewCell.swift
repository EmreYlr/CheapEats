//
//  OrdersTableViewCell.swift
//  CheapEats
//
//  Created by CANSU on 30.11.2024.
//

import UIKit
import Kingfisher

class OrdersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ordersImageView: UIImageView!
    @IBOutlet weak var foodNameLbl: UILabel!
    @IBOutlet weak var companyNameLbl: UILabel!
    @IBOutlet weak var orderDateLbl: UILabel!
    @IBOutlet weak var orderDeliveryStatusLbl: UILabel!
    @IBOutlet weak var orderColorStatus: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .textWhite
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10))
        contentView.layer.cornerRadius = 10
        contentView.layer.borderColor = UIColor(named: "ButtonColor")?.cgColor
        contentView.layer.borderWidth = 1
        ordersImageView.layer.borderColor = UIColor(named: "ButtonColor")?.cgColor
        ordersImageView.layer.borderWidth = 1
        
    }
    
    func configureCell(with ordersDetail: OrderDetail) {
        ordersImageView.kf.indicatorType = .activity
        ordersImageView.kf.setImage(with: URL(string: ordersDetail.productDetail.product.imageUrl))
        foodNameLbl.text = ordersDetail.productDetail.product.name
        companyNameLbl.text = ordersDetail.productDetail.restaurant.name
        orderDateLbl.text = dateFormatter(with: ordersDetail.userOrder.orderDate)
        let status = ordersDetail.userOrder.status
        orderDeliveryStatusLbl.text = status.rawValue
        switch status {
        case .delivered:
            orderDeliveryStatusLbl.textColor = .button
            orderColorStatus.tintColor = .button
            orderColorStatus.image = UIImage(systemName: "checkmark")
        case .preparing:
            orderDeliveryStatusLbl.textColor = .systemOrange
            orderColorStatus.tintColor = .systemOrange
            orderColorStatus.image = UIImage(systemName: "clock")
        case .canceled:
            orderDeliveryStatusLbl.textColor = .cut
            orderColorStatus.tintColor = .cut
            orderColorStatus.image = UIImage(systemName: "xmark")
        }
         
    }
}
