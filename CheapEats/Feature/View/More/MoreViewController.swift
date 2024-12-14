//
//  MoreViewController.swift
//  CheapEats
//
//  Created by Emre on 29.11.2024.
//

import UIKit

final class MoreViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var notProductView: UIView!
    
    var moreViewModel : MoreViewModelProtocol = MoreViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        moreViewModel.delegate = self
        initTableView()
        initSearchController()
        print("More")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = UIColor(named: "ButtonColor")
        filterButton.tintColor = UIColor(named: "ButtonColor")
    }
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "FoodTableViewCell", bundle: nil), forCellReuseIdentifier: "foodcell")
        tableView.layer.cornerRadius = 10
        
    }
    
    func initSearchController() {
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = "Ara..."
    }
    
    @IBAction func filterButtonClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let filterVC = storyboard.instantiateViewController(withIdentifier: "FilterViewController") as? FilterViewController {
            filterVC.delegate = self
            moreViewModel.emptyCheckSelectedItem(filterVC: filterVC)
            navigationController?.pushViewController(filterVC, animated: true)
        }
    }
}
//MARK: -MoreViewModelOutputProtocol
extension MoreViewController: MoreViewModelOutputProtocol {
    func update() {
        tableView.reloadData()
    }
    
    func error() {
        print("Error")
    }
}
//MARK: -FilterViewModelOutputProtocol
extension MoreViewController: FilterViewModelOutputProtocol {
    func didApplyFilter(selectedMealTypes: [MealType], minMealPrice: Int, distance: Int) {
        moreViewModel.applyFilterItem(selectedMealTypes: selectedMealTypes, minMealPrice: minMealPrice, distance: distance)
        print("Filter Applied")
        print(selectedMealTypes)
        print(minMealPrice)
        print(distance)
    }
}

