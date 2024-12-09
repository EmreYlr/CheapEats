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
        ordersImageView.layer.cornerRadius = 10
        contentView.layer.cornerRadius = 10
        contentView.layer.borderColor = UIColor(named: "ButtonColor")?.cgColor
        contentView.layer.borderWidth = 1
        ordersImageView.layer.cornerRadius = 10
        ordersImageView.layer.borderColor = UIColor(named: "BG")?.cgColor
        ordersImageView.layer.borderWidth = 1
        
    }
 
}
