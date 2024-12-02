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
        contentView.roundCorners(corners: [.allCorners], radius: 10, borderColor: UIColor(named: "ButtonColor"), borderWidth: 2)
        ordersImageView.roundCorners(corners: [.allCorners], radius: 10, borderColor: UIColor(named: "BG"), borderWidth: 0)
    }
 
}
