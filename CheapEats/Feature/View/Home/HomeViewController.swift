//
//  ViewController.swift
//  CheapEats
//
//  Created by Emre on 24.11.2024.
//

import UIKit
import CoreLocation
import NVActivityIndicatorView

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
    @IBOutlet weak var waitView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var loadIndicator: NVActivityIndicatorView!
    var homeViewModel : HomeViewModelProtocol = HomeViewModel()
    let SB = UIStoryboard(name: "Main", bundle: nil)
    let refreshControl = UIRefreshControl()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingIndicator()
        homeViewModel.delegate = self
        initLoad()
        initScreen()
        updateUserInfo()
        NotificationCenter.default.addObserver(self, selector: #selector(userProfileUpdated), name: NSNotification.Name("UserProfileUpdated"), object: nil)
         
    }
    func initScreen() {
        collectionViewSettings(with: endlingCollectionView)
        collectionViewSettings(with: recommendedCollectionView)
        collectionViewSettings(with: closeCollectionView)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        accessView.isHidden = homeViewModel.checkLocationPermission(with: locationManager)
        if accessView.isHidden {
            startLocationServices()
        }
        homeViewModel.fetchData()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.tintColor = UIColor(named: "ButtonColor")
        scrollView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopLocationServices()
    }
    
    func startLocationServices() {
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationServices() {
        locationManager.stopUpdatingLocation()
    }
    
    @objc func refreshData() {
        refreshLocation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.homeViewModel.fetchData()
            self.refreshControl.endRefreshing()
        }
    }
    private func refreshLocation() {
        if self.homeViewModel.checkLocationPermission(with: self.locationManager) {
            self.startLocationServices()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func userProfileUpdated() {
        homeViewModel.refreshUserData()
        updateUserInfo()
    }
    private func setupLoadingIndicator() {
        loadIndicator = createLoadingIndicator(in: waitView)
    }

    private func initLoad(){
        initCollectionView(with: closeCollectionView)
        initCollectionView(with: endlingCollectionView)
        initCollectionView(with: recommendedCollectionView)
    }
    
    private func updateUserInfo() {
        if let user = homeViewModel.user {
            helloLabel.text = "Hello, \(user.firstName) \(user.lastName)"
        }
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
        moreVC.moreViewModel.productDetail = homeViewModel.endlingProduct
        navigationController?.pushViewController(moreVC, animated: true)
    }
    
    @IBAction func recommendedMoreButtonClicked(_ sender: Any) {
        let moreVC = SB.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
        moreVC.navigationItem.title = "Önerilenler"
        moreVC.moreViewModel.productDetail = homeViewModel.recommendedProduct
        navigationController?.pushViewController(moreVC, animated: true)
    }
    
    @IBAction func closeMoreButtonClicked(_ sender: Any) {
        let moreVC = SB.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
        moreVC.navigationItem.title = "En Yakındakiler"
        moreVC.moreViewModel.productDetail = homeViewModel.closeProduct
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
        homeViewModel.collectionLoad()
        print("Update")
    }
    
    func updateCollection() {
        closeCollectionView.reloadData()
        endlingCollectionView.reloadData()
        recommendedCollectionView.reloadData()
        print("Update Collection")
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
