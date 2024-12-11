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
    @IBOutlet weak var closeMoreButton: UIButton!
    @IBOutlet weak var closeCollectionView: UICollectionView!
    var homeViewModel : HomeViewModelProtocol = HomeViewModel()
    let SB = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeViewModel.delegate = self
        initLoad()
        collectionViewLayoutSettings()
        endlingViewLayoutSettings()
        closeViewLayoutSettings()
    }
    
    private func initLoad(){
        if let user = homeViewModel.user {
            helloLabel.text = "Hello, \(user.firstName)"
        }
        initCollectionView(with: closeCollectionView)
        initCollectionView(with: endlingCollectionView)
        initCollectionView(with: recommendedCollectionView)
    }   
    
    private func initCollectionView(with collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.register(UINib(nibName: "OrderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
    }
}
//MARK: -Button Actions
extension HomeViewController {
    @IBAction func endlingMoreButtonClicked(_ sender: Any) {
        let moreVC = SB.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
        moreVC.navigationItem.title = "Son Eklenenler"
        moreVC.moreViewModel.products = homeViewModel.endlingProduct
        navigationController?.pushViewController(moreVC, animated: true)
    }
    
    @IBAction func recommendedMoreButtonClicked(_ sender: Any) {
        let moreVC = SB.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
        moreVC.navigationItem.title = "Önerilenler"
        moreVC.moreViewModel.products = homeViewModel.recommendedProduct
        navigationController?.pushViewController(moreVC, animated: true)
    }
    
    @IBAction func closeMoreButtonClicked(_ sender: Any) {
        let moreVC = SB.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
        moreVC.navigationItem.title = "En Yakındakiler"
        moreVC.moreViewModel.products = homeViewModel.closeProduct
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
