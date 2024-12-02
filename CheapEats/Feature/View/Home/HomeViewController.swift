//
//  ViewController.swift
//  CheapEats
//
//  Created by Emre on 24.11.2024.
//

import UIKit

final class HomeViewController: UIViewController{
    //MARK: -Variables
    @IBOutlet weak var endlingCollectionView: UICollectionView!
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var endlingMoreButton: UIButton!
    @IBOutlet weak var recommendedMoreButton: UIButton!
    @IBOutlet weak var recommendedCollectionView: UICollectionView!
    var homeViewModel : HomeViewModelProtocol = HomeViewModel()
    let SB = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeViewModel.delegate = self
        initLoad()
        collectionViewLayoutSettings()
        endlingViewLayoutSettings()
    }
    
    private func initLoad(){
        if let user = homeViewModel.user {
            helloLabel.text = "Hello, \(user.firstName)"
        }
        endlingCollectionView.dataSource = self
        endlingCollectionView.delegate = self
        endlingCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        endlingCollectionView.register(UINib(nibName: "OrderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        recommendedCollectionView.dataSource = self
        recommendedCollectionView.delegate = self
        recommendedCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        recommendedCollectionView.register(UINib(nibName: "OrderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
    }    
}
//MARK: -Button Actions
extension HomeViewController {
    @IBAction func endlingMoreButtonClicked(_ sender: Any) {
        let moreVC = SB.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
        moreVC.navigationItem.title = "Son Eklenenler"
        navigationController?.pushViewController(moreVC, animated: true)
    }
    
    @IBAction func recommendedMoreButtonClicked(_ sender: Any) {
        let moreVC = SB.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
        moreVC.navigationItem.title = "Önerilenler"
        navigationController?.pushViewController(moreVC, animated: true)
        
    }
}
//MARK: -Output Protocol
extension HomeViewController : HomeViewModelOutputProtocol {
    func update() {
        print("Update")
    }
    
    func error() {
        print("Error")
    }
}
