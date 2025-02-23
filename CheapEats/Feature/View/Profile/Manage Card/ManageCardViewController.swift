//
//  ManageCardViewController.swift
//  CheapEats
//
//  Created by Emre on 22.02.2025.
//

import UIKit
import NVActivityIndicatorView

final class ManageCardViewController: UIViewController {
    //MARK: -Variables
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var waitView: UIView!
    private var loadIndicator: NVActivityIndicatorView!
    
    var manageCardViewModel: ManageCardViewModelProtocol = ManageCardViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        setupLoadingIndicator()
        initScreen()
        print("ManageCardViewController")
    }
    
    private func setupLoadingIndicator() {
        loadIndicator = createLoadingIndicator(in: waitView)
    }
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ManageCardTableViewCell", bundle: nil), forCellReuseIdentifier: "cardCell")
        tableView.register(UINib(nibName: "AddManageCardTableViewCell", bundle: nil), forCellReuseIdentifier: "addCardCell")
    }
    
    func initScreen() {
        manageCardViewModel.delegate = self
        manageCardViewModel.fetchUserCreditCards()
    }
}

extension ManageCardViewController: ManageCardViewModelOutputProtocol {
    func update() {
        tableView.reloadData()
        print("Update")
    }
    
    func error() {
        print("Error")
    }
    
    func didDeleteCard(at indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
    
    func startLoading() {
        waitView.isHidden = false
        loadIndicator.isHidden = false
        loadIndicator.startAnimating()
    }
    
    func stopLoading() {
        waitView.isHidden = true
        loadIndicator.isHidden = true
        loadIndicator.stopAnimating()
    }
}
