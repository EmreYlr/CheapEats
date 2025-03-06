//
//  MapCollectionViewCell.swift
//  CheapEats
//
//  Created by Emre on 5.03.2025.
//

import UIKit
import Kingfisher

class MapCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var newPriceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var productDetailButton: UIButton!
    var detailButtonTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10
        setShadow(with: self.layer, shadowOffset: true)
        setBorder(with: imageView.layer)
        setShadow(with: imageView.layer, shadowOffset: true)
        imageView.layer.masksToBounds = true
        
    }
    
    func configure(productDetail: ProductDetails) {
        imageView.kf.setImage(with: URL(string: productDetail.product.imageUrl))
        imageView.kf.indicatorType = .activity
        companyNameLabel.text = productDetail.restaurant.companyName
        mealNameLabel.text = productDetail.product.name
        oldPriceLabel.text = "\(productDetail.product.oldPrice) TL"
        newPriceLabel.text = "\(productDetail.product.newPrice) TL"
        distanceLabel.text = "850m"
    }
    
    @IBAction func detailButtonClicked(_ sender: UIButton) {
        detailButtonTapped?()
    }
}
