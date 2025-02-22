//
//  ManageCardViewController+TableView.swift
//  CheapEats
//
//  Created by Emre on 22.02.2025.
//

import UIKit

extension ManageCardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 5 {
            let addCell = tableView.dequeueReusableCell(withIdentifier: "addCardCell", for: indexPath) as! AddManageCardTableViewCell
            addCell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            addCell.selectionStyle = .none
            return addCell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as! ManageCardTableViewCell
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            cell.cardNameLabel.text = "Öğrenci Kartım"
            cell.cardNoLabel.text = "1234 5678 9101 1121"
            cell.cardImageView.image = UIImage(named: "VisaLogo")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row < 5
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
