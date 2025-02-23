//
//  ManageCardViewController+TableView.swift
//  CheapEats
//
//  Created by Emre on 22.02.2025.
//

import UIKit

extension ManageCardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manageCardViewModel.userCreditCards.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == manageCardViewModel.userCreditCards.count {
            let addCell = tableView.dequeueReusableCell(withIdentifier: "addCardCell", for: indexPath) as! AddManageCardTableViewCell
            addCell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            addCell.selectionStyle = .none
            return addCell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as! ManageCardTableViewCell
            cell.selectionStyle = .gray
            cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            cell.configureCell(with: manageCardViewModel.userCreditCards[indexPath.row])
            cell.trashButtonTapped = { [weak self] in
                guard let self = self else { return }
                self.showTwoButtonAlert(title: "Uyarı!", message: "Kayıtlı kart silinecek emin misiniz?", firstButtonTitle: "Sil", firstButtonHandler: { _ in
                    let cardId = self.manageCardViewModel.userCreditCards[indexPath.row].cardId
                    self.manageCardViewModel.deleteUserCreditCard(at: cardId, indexPath: indexPath)
                }, secondButtonTitle: "İptal", secondButtonHandler: nil)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == manageCardViewModel.userCreditCards.count {
            let SB = UIStoryboard(name: "Main", bundle: nil)
            let addCardVC = SB.instantiateViewController(withIdentifier: "AddCardViewController") as! AddCardViewController
            navigationController?.pushViewController(addCardVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row < manageCardViewModel.userCreditCards.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            showTwoButtonAlert(title: "Uyarı!", message: "Kayıtlı kart silinecek emin misiniz?", firstButtonTitle: "Sil", firstButtonHandler: { _ in
                let cardId = self.manageCardViewModel.userCreditCards[indexPath.row].cardId
                self.manageCardViewModel.deleteUserCreditCard(at: cardId, indexPath: indexPath)
            }, secondButtonTitle: "İptal", secondButtonHandler: nil)
            
        }
    }
}
