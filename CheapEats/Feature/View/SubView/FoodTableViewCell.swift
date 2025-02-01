//
//  FoodTableViewCell.swift
//  CheapEats
//
//  Created by Emre on 29.11.2024.
//

import UIKit
import Kingfisher

final class FoodTableViewCell: UITableViewCell {

    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var oldAmountLabel: UILabel!
    @IBOutlet weak var newAmountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .BG
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))
        foodImageView.roundCorners(corners: [.topLeft, .topRight], radius: 10, borderColor: UIColor(named: "ButtonColor"), borderWidth: 1)
        detailView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10, borderColor: UIColor(named: "ButtonColor"), borderWidth: 1)
        foodImageView.layer.opacity = 0.8
        self.layer.borderWidth = 0
    }
    
    func configureCell(product: Product) {
        companyNameLabel.text = product.restaurantName
        dateLabel.text = dateFormatter(with: product.createdAt)
        foodNameLabel.text = product.name
        oldAmountLabel.text = product.oldPrice
        newAmountLabel.text = product.newPrice
        foodImageView.kf.indicatorType = .activity
        foodImageView.kf.setImage(with: URL(string: product.imageUrl))
    }

}
