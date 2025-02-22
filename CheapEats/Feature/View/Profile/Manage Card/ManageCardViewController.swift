//
//  ManageCardViewController.swift
//  CheapEats
//
//  Created by Emre on 22.02.2025.
//

import UIKit

final class ManageCardViewController: UIViewController {
    //MARK: -Variables
    @IBOutlet weak var tableView: UITableView!
    var manageCardViewModel: ManageCardViewModelProtocol = ManageCardViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        print("ManageCardViewController")
    }
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ManageCardTableViewCell", bundle: nil), forCellReuseIdentifier: "cardCell")
        tableView.register(UINib(nibName: "AddManageCardTableViewCell", bundle: nil), forCellReuseIdentifier: "addCardCell")
    }
}
