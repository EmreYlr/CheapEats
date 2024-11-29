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
        print("Hello World")
        homeViewModel.delegate = self
        initLoad()
        collectionViewLayoutSettings()
        endlingViewLayoutSettings()
        //TODO:
        if let user = UserManager.shared.user {
            helloLabel.text = "Hello, \(user.firstName)"
        }
    }
    
    private func initLoad(){
        endlingCollectionView.dataSource = self
        endlingCollectionView.delegate = self
        endlingCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        endlingCollectionView.register(UINib(nibName: "OrderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        recommendedCollectionView.dataSource = self
        recommendedCollectionView.delegate = self
        recommendedCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        recommendedCollectionView.register(UINib(nibName: "OrderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
    }
    
    
    private func collectionViewLayoutSettings() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        endlingCollectionView.collectionViewLayout = layout
        endlingCollectionView.isPagingEnabled = false
        endlingCollectionView.showsHorizontalScrollIndicator = false
        endlingCollectionView.backgroundColor = .BG
        endlingCollectionView.layer.cornerRadius = 10
    }
    private func endlingViewLayoutSettings() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        recommendedCollectionView.collectionViewLayout = layout
        recommendedCollectionView.isPagingEnabled = false
        recommendedCollectionView.showsHorizontalScrollIndicator = false
        recommendedCollectionView.backgroundColor = .BG
        recommendedCollectionView.layer.cornerRadius = 10
    }
    
    @IBAction func endlingMoreButtonClicked(_ sender: Any) {
        let moreVC = SB.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
        navigationController?.pushViewController(moreVC, animated: true)
    }
    
    @IBAction func recommendedMoreButtonClicked(_ sender: Any) {
        let moreVC = SB.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
        navigationController?.pushViewController(moreVC, animated: true)
        
    }
}

extension HomeViewController : HomeViewModelOutputProtocol {
    func update() {
        print("Update")
    }
    
    func error() {
        print("Error")
    }
}
