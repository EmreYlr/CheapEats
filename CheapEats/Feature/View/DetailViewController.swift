//
//  DetailViewController.swift
//  CheapEats
//
//  Created by Emre on 29.11.2024.
//

import UIKit

final class DetailViewController: UIViewController,UIScrollViewDelegate {
    //MARK: -Variables
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
    
    var detailViewModel: DetailViewModelProtocol = DetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .button
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
        
        print("Detail")
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
