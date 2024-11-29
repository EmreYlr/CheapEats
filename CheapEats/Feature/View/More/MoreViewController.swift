//
//  MoreViewController.swift
//  CheapEats
//
//  Created by Emre on 29.11.2024.
//

import UIKit

final class MoreViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var moreViewModel : MoreViewModelProtocol = MoreViewModel()
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        moreViewModel.delegate = self
        initTableView()
        initSearchController()
        print("More")
        
    }
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FoodTableViewCell", bundle: nil), forCellReuseIdentifier: "foodcell")
        tableView.layer.cornerRadius = 10
        
    }
    
    func initSearchController() {
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = "Ara..."
    }
    
    @IBAction func filterButtonClicked(_ sender: Any) {
        print("Filter")
    }
}

extension MoreViewController: MoreViewModelOutputProtocol {
    func update() {
        print("Update")
    }
    
    func error() {
        print("Error")
    }
}
