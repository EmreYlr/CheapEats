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
    
    func configureCell(productDetail: ProductDetails) {
        companyNameLabel.text = productDetail.restaurant.name
        dateLabel.text = dateFormatter(with: productDetail.product.createdAt)
        foodNameLabel.text = productDetail.product.name
        oldAmountLabel.text = productDetail.product.oldPrice
        newAmountLabel.text = productDetail.product.newPrice
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: URL(string: productDetail.product.imageUrl))
    }

}
