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
        descriptonLabel.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries."
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
