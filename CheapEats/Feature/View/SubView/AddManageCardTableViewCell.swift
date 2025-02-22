//
//  AddManageCardTableViewCell.swift
//  CheapEats
//
//  Created by Emre on 23.02.2025.
//

import UIKit

class AddManageCardTableViewCell: UITableViewCell {
    //MARK: -Variables
    @IBOutlet weak var addImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .textWhite
        addImageView.layer.borderColor = UIColor.lightGray.cgColor
        addImageView.layer.cornerRadius = 4
        addImageView.layer.borderWidth = 0.5
        setShadow(with: self.layer, shadowOffset: true)
        
    }
}
