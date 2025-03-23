//
//  CardSelectViewController.swift
//  CheapEats
//
//  Created by Emre on 23.03.2025.
//

import UIKit
import NVActivityIndicatorView

final class CardSelectViewController: UIViewController {
    //MARK: -Variables
    @IBOutlet weak var cardNavigationBar: UINavigationBar!
    @IBOutlet weak var cardTableView: UITableView!
    @IBOutlet weak var waitView: UIView!
    
    private var loadIndicator: NVActivityIndicatorView!
    weak var delegate: CardSelectViewModelDelegate?
    var cardSelectViewModel: CardSelectViewModelProtocol = CardSelectViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingIndicator()
        setupNavigationBar()
        setupTableView()
        cardSelectViewModel.delegate = self
        cardSelectViewModel.getCreditCards()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Kart Seçiniz"
        let cancelButton = UIBarButtonItem(title: "İptal", style: .plain, target: self, action: #selector(cancelButtonTapped))
        cancelButton.tintColor = UIColor(named: "CutColor")
        navigationItem.rightBarButtonItem = cancelButton
        cardNavigationBar.setItems([navigationItem], animated: false)
    }
    
    private func setupTableView() {
        self.cardTableView.delegate = self
        self.cardTableView.dataSource = self
    }
    
    private func setupLoadingIndicator() {
        loadIndicator = createLoadingIndicator(in: waitView)
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
}

extension CardSelectViewController: CardSelectViewModelOutputProtocol {
    func update() {
        print("Update")
        cardTableView.reloadData()
    }
    
    func error() {
        print("Error")
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
