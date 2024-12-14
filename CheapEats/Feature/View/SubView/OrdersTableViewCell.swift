//
//  OrdersTableViewCell.swift
//  CheapEats
//
//  Created by CANSU on 30.11.2024.
//

import UIKit

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
    func configureCell(with orders: Orders) {
        ordersImageView.image = UIImage(named: orders.imageUrl)
        foodNameLbl.text = orders.food
        companyNameLbl.text = orders.company
        orderDateLbl.text = orders.date
        
        let status = orders.orderStatus
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
