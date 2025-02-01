//
//  OrderCollectionViewCell.swift
//  CheapEats
//
//  Created by Emre on 26.11.2024.
//

import UIKit

class OrderCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
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
        imageView.roundCorners(corners: [.topLeft, .topRight], radius: 10, borderColor: UIColor(named: "ButtonColor"), borderWidth: 1)
        imageView.layer.opacity = 0.8
        detailView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10, borderColor: UIColor(named: "ButtonColor"), borderWidth: 1)
    }
    
    func configureCell(product: Product) {
        companyNameLabel.text = product.restaurantName
        dateLabel.text = dateFormatter(with: product.createdAt)
        foodNameLabel.text = product.name
        oldAmountLabel.text = product.oldPrice
        newAmountLabel.text = product.newPrice
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: URL(string: product.imageUrl))
    }

}
