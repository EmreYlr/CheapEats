//
//  DetailViewController.swift
//  CheapEats
//
//  Created by Emre on 29.11.2024.
//

import UIKit
import MapKit

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
    
    var detailViewModel: DetailViewModelProtocol = DetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initScreen()
        print("Detail")
    }
    
    private func initScreen() {
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
        
        if let product = detailViewModel.product {
            imageView.image = UIImage(named: product.imageUrl)
            foodNameLabel.text = product.name
            foodLabel.text = String(describing: product.category.first!)
            companyNameLabel.text = product.restaurantName
            dateLabel.text = dateFormatter(with: product.createdAt)
            oldAmountLabel.text = product.oldPrice
            newAmountLabel.text = product.newPrice
            descriptonLabel.text = product.description
            deliveryLabel.text = product.deliveryType.rawValue
            timeLabel.text = product.endDate
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
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
}
