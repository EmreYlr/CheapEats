//
//  CartTableViewCell.swift
//  CheapEats
//
//  Created by Emre on 20.03.2025.
//

import UIKit
import Kingfisher

final class CartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cartImageView: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var decreaseButton: UIButton!
    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var countView: UIView!
    
    var callback : ((Int) -> ())?
    var deleteCallback: (() -> ())?
    var productDetails: ProductDetails?
    
    var count = 1 {
        didSet {
            countLabel.text = "\(count)"
            if let maxQuantity = productDetails?.product.quantity {
                increaseButton.isEnabled = count < maxQuantity
                increaseButton.alpha = count < maxQuantity ? 1 : 0.5
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .BG
        contentView.backgroundColor = .white
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        
        contentView.layer.cornerRadius = 10
        setShadow(with: contentView.layer, shadowOffset: true)
        cartImageView.layer.borderWidth = 0.2
        cartImageView.layer.cornerRadius = 5
        cartImageView.layer.masksToBounds = true
        cartImageView.clipsToBounds = true
        countView.backgroundColor = .white
        
        increaseButton.layer.cornerRadius = 5
        decreaseButton.layer.cornerRadius = 5
    }
    
    func configureCell(product: ProductDetails) {
        self.productDetails = product
        cartImageView.kf.setImage(with: URL(string: product.product.imageUrl))
        foodNameLabel.text = product.product.name
        priceLabel.text = "\(formatDouble(product.product.newPrice)) TL"
        count = product.product.selectedCount
        countLabel.text = "\(count)"
        
        
        increaseButton.isEnabled = count < product.product.quantity
        increaseButton.alpha = count < product.product.quantity ? 1 : 0.5
    }
    
    @IBAction func increaseButtonClicked(_ sender: UIButton) {
        if let product = productDetails, count >= product.product.quantity {
            return
        }
        
        count += 1
        callback?(count)
    }
    
    @IBAction func decreaseButtonClicked(_ sender: UIButton) {
        if count <= 1 {
            deleteCallback?()
            return
        }
        
        count -= 1
        callback?(count)
    }
}
