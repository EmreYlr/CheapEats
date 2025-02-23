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
    var trashButtonTapped: (() -> Void)?
    
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
    
    func configureCell(with card: UserCreditCards) {
        switch card.cardType {
        case .visa:
            cardImageView.image = UIImage(named: "VisaLogo")
        case .mastercard:
            cardImageView.image = UIImage(named: "MCLogo")
        case .troy:
            cardImageView.image = UIImage(named: "troyLogo")
        case .unknown:
            cardImageView.image = UIImage(named: "unknown")
        }
        cardNameLabel.text = card.cardName
        cardNoLabel.text = card.cardNo
    }
    
    @IBAction func trashButtonClicked(_ sender: UIButton) {
        trashButtonTapped?()
    }
    
}
