//
//  ViewController.swift
//  CheapEats
//
//  Created by Emre on 24.11.2024.
//

import UIKit
import CoreLocation

final class HomeViewController: UIViewController{
    //MARK: -Variables
    @IBOutlet weak var endlingCollectionView: UICollectionView!
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var endlingMoreButton: UIButton!
    @IBOutlet weak var recommendedMoreButton: UIButton!
    @IBOutlet weak var recommendedCollectionView: UICollectionView!
    @IBOutlet weak var closeMoreButton: UIButton!
    @IBOutlet weak var closeCollectionView: UICollectionView!
    @IBOutlet weak var accessView: UIView!
    @IBOutlet weak var locationDescriptionLabel: UILabel!
    var homeViewModel : HomeViewModelProtocol = HomeViewModel()
    let SB = UIStoryboard(name: "Main", bundle: nil)
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeViewModel.delegate = self
        initLoad()
        collectionViewSettings(with: endlingCollectionView)
        collectionViewSettings(with: recommendedCollectionView)
        collectionViewSettings(with: closeCollectionView)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        accessView.isHidden = homeViewModel.checkLocationPermission(with: locationManager)
        homeViewModel.fetchProducts()
    }

    private func initLoad(){
        if let user = homeViewModel.user {
            helloLabel.text = "Hello, \(user.firstName) \(user.lastName)"
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
    
    @IBAction func accessButonClicked(_ sender: UIButton) {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
}
//MARK: -Output Protocol
extension HomeViewController : HomeViewModelOutputProtocol {
    func update() {
        endlingCollectionView.reloadData()
        recommendedCollectionView.reloadData()
        closeCollectionView.reloadData()
        print("Update")
    }
    
    func error() {
        print("Error")
    }
}
