//
//  CartSelectViewController+TableView.swift
//  CheapEats
//
//  Created by Emre on 23.03.2025.
//

import Foundation
import UIKit

extension CardSelectViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardSelectViewModel.userCreditCards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CardCell")
        let userCreditCard = cardSelectViewModel.userCreditCards[indexPath.row]
        cell.textLabel?.text = userCreditCard.cardName
        cell.detailTextLabel?.text = "**** **** **** \(userCreditCard.cardNo.suffix(4))"
        let cardTypeImage: UIImage?
        switch userCreditCard.cardType {
        case .visa:
            cardTypeImage = UIImage(named: "VisaLogo")
        case .mastercard:
            cardTypeImage = UIImage(named: "MCLogo")
        case .troy:
            cardTypeImage = UIImage(named: "troyLogo")
        case .unknown:
            cardTypeImage = UIImage(named: "Unknown")
        }
        
        if let cardTypeImage = cardTypeImage {
            let imageView = UIImageView(image: cardTypeImage)
            imageView.contentMode = .scaleAspectFit
            let imageSize: CGFloat = 30
            imageView.frame = CGRect(x: 0, y: 0, width: imageSize, height: imageSize)
            cell.accessoryView = imageView
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOption = cardSelectViewModel.userCreditCards[indexPath.row]
        cardSelectViewModel.selectedCard = selectedOption
        delegate?.didApplySelection(selectedOption: cardSelectViewModel.getSelectedCard())
        dismiss(animated: true)
    }
}
