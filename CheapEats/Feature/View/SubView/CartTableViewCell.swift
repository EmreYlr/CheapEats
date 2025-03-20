//
//  CartTableViewCell.swift
//  CheapEats
//
//  Created by Emre on 20.03.2025.
//

import UIKit

final class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var cartImageView: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var decreaseButton: UIButton!
    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var countView: UIView!
    
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

        setShadow(with: cartImageView.layer, shadowOffset: true)
        cartImageView.layer.cornerRadius = 5
        cartImageView.layer.masksToBounds = true
        cartImageView.clipsToBounds = true
        countView.backgroundColor = .white
        
        increaseButton.layer.cornerRadius = 5
        decreaseButton.layer.cornerRadius = 5
    }
    
    func configureCell(product: ProductDetails) {
        cartImageView.image = UIImage(named: "Logo")
        foodNameLabel.text = product.product.name
        priceLabel.text = "\(product.product.newPrice) TL"
        countLabel.text = "1"
    }
    
    func fakeConfigure() {
        cartImageView.image = UIImage(named: "VisaLogo")
        foodNameLabel.text = "Test Food"
        priceLabel.text = "150 TL"
        countLabel.text = "1"
    }
    
}
