//
//  FoodTableViewCell.swift
//  CheapEats
//
//  Created by Emre on 29.11.2024.
//

import UIKit

class FoodTableViewCell: UITableViewCell {

    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var detailView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .textWhite
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
        foodImageView.roundCorners(corners: [.topLeft, .topRight], radius: 10, borderColor: UIColor(named: "ButtonColor"), borderWidth: 1)
        detailView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10, borderColor: UIColor(named: "ButtonColor"), borderWidth: 2)
        self.layer.borderWidth = 0

    }

}
