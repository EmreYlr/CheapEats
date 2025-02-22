//
//  ManageCardTableViewCell.swift
//  CheapEats
//
//  Created by Emre on 22.02.2025.
//

import UIKit

class ManageCardTableViewCell: UITableViewCell {
    //MARK: -Variables
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardNoLabel: UILabel!
    @IBOutlet weak var trashButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .textWhite
        cardImageView.layer.borderColor = UIColor.lightGray.cgColor
        cardImageView.layer.cornerRadius = 4
        cardImageView.layer.borderWidth = 0.5
    }
    
}
