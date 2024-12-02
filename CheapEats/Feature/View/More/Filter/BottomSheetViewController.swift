//
//  BottomSheetViewController.swift
//  CheapEats
//
//  Created by Emre on 2.12.2024.
//

import UIKit

final class BottomSheetViewController: UIViewController {
    //MARK: -Variables
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var applyButton: UIButton!
    var bottomSheetViewModel: BottomSheetViewModelProtocol = BottomSheetViewModel()
    weak var delegate: BottomSheetViewModelDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        bottomSheetViewModel.delegate = self
        applyButton.roundCorners(corners: [.allCorners], radius: 10)
    }
    
    func setupNavigationBar() {
        let clearButton = UIBarButtonItem(title: "Temizle", style: .plain, target: self, action: #selector(clearButtonTapped))
        clearButton.tintColor = UIColor(named: "ButtonColor")
        navigationItem.rightBarButtonItem = clearButton
        navigationItem.title = "Yemek Türleri"
        navigationBar.setItems([navigationItem], animated: false)
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsMultipleSelection = true
    }
    
    @IBAction func applyButtonClicked(_ sender: Any) {
        delegate?.didApplySelection(selectedOptions: bottomSheetViewModel.selectedOptions)
        dismiss(animated: true)
    }
    
    @objc private func clearButtonTapped() {
        bottomSheetViewModel.clearSelection(tableView: tableView)
    }
}

extension BottomSheetViewController: BottomSheetViewModelOutputProtocol {
    func didChangeSelection() {
        tableView.reloadData()
    }
}
