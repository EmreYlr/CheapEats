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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        imageView.layer.opacity = 0.8
        detailView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10, borderColor: UIColor(named: "ButtonColor"), borderWidth: 0.5)
    }

}
