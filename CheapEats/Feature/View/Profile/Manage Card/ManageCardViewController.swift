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
    private var refreshControl: UIRefreshControl!
    
    var manageCardViewModel: ManageCardViewModelProtocol = ManageCardViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        setupLoadingIndicator()
        initRefreshControl()
        initScreen()
        print("ManageCardViewController")
    }
    private func initRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .button
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc private func refreshData() {
        manageCardViewModel.fetchUserCreditCards(isRefreshing: false)
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
        manageCardViewModel.fetchUserCreditCards(isRefreshing: true)
    }
}

extension ManageCardViewController: ManageCardViewModelOutputProtocol {
    func update() {
        tableView.reloadData()
        refreshControl.endRefreshing()
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

extension ManageCardViewController: AddCardViewControllerDelegate {
    func didAddCard(_ card: UserCreditCards) {
        manageCardViewModel.userCreditCards.append(card)
        tableView.reloadData()
    }
}
