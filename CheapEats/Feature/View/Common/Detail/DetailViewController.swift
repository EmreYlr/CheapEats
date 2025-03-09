//
//  DetailViewController.swift
//  CheapEats
//
//  Created by Emre on 29.11.2024.
//

import UIKit
import MapKit
import NVActivityIndicatorView

final class DetailViewController: UIViewController {
    //MARK: -Variables
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var foodView: UIView!
    @IBOutlet weak var distanceView: UIView!
    @IBOutlet weak var foodImageIcon: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var distanceImageIcon: UIImageView!
    @IBOutlet weak var deliveryImageIcon: UIImageView!
    @IBOutlet weak var deliveryView: UIView!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var timeImageIcon: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptonLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var payView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var oldAmountLabel: UILabel!
    @IBOutlet weak var newAmountLabel: UILabel!
    @IBOutlet weak var waitView: UIView!
    private var loadIndicator: NVActivityIndicatorView!
    var detailViewModel: DetailViewModelProtocol = DetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingIndicator()
        configureMapView()
        initScreen()
        print("Detail")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = UIColor(named: "ButtonColor")
    }
    
    private func setupLoadingIndicator() {
        loadIndicator = createLoadingIndicator(in: waitView)
    }
    
    @objc func shareButtonClicked() {
        let textToShare = "www.cheapeats.com/product/\(detailViewModel.productDetail?.product.productId ?? "")"
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func initScreen() {
        let shareButton = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(shareButtonClicked))
        shareButton.image = UIImage(systemName: "square.and.arrow.up")
        navigationItem.rightBarButtonItem = shareButton
        
        scrollView.delegate = self
        detailViewModel.delegate = self
        distanceImageIcon.image = UIImage(systemName: "point.filled.topleft.down.curvedto.point.bottomright.up")
        imageView.layer.cornerRadius = 10
        distanceView.layer.cornerRadius = 5
        foodView.layer.cornerRadius = 5
        foodImageIcon.layer.cornerRadius = 3
        distanceImageIcon.layer.cornerRadius = 3
        deliveryImageIcon.layer.cornerRadius = 3
        timeImageIcon.layer.cornerRadius = 3
        timeView.layer.cornerRadius = 5
        deliveryView.layer.cornerRadius = 5
        mapView.layer.cornerRadius = 10
        configureView(confirmButton, cornerRadius: 10)
        configureView(payView, cornerRadius: 10, borderColor: .button, borderWidth: 2)
        
        if let productDetail = detailViewModel.productDetail {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: URL(string: productDetail.product.imageUrl))
            foodNameLabel.text = productDetail.product.name
            foodLabel.text = String(describing: productDetail.product.category.first!)
            companyNameLabel.text = productDetail.restaurant.companyName
            dateLabel.text = dateFormatter(with: productDetail.product.createdAt)
            oldAmountLabel.text = "\(formatDouble(productDetail.product.oldPrice)) TL"
            newAmountLabel.text = "\(formatDouble(productDetail.product.newPrice)) TL"
            descriptonLabel.text = productDetail.product.description
            deliveryLabel.text = productDetail.product.deliveryType.rawValue
            timeLabel.text = productDetail.product.endDate
        }
    }
    
    func configureMapView() {
        mapView.delegate = self
        mapView.showsCompass = false
        mapView.showsScale = false
        mapView.showsTraffic = false
        mapView.showsBuildings = false
        mapView.showsLargeContentViewer = false
        mapView.pointOfInterestFilter = MKPointOfInterestFilter(including: MKPointOfInterestCategory.defaultCategoriesToShow)
        detailViewModel.mapViewCenterCoordinate(mapView: mapView)
        detailViewModel.getRoutuerDistance { distance in
            self.distanceLabel.text = distance
        }
    }
    
    @IBAction func confirmButtonClicked(_ sender: UIButton) {
    }
    
}

extension DetailViewController: DetailViewModelOutputProtocol {
    func update() {
        print("update")
    }
    
    func error() {
        print("error")
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

