//
//  DeliveryViewController.swift
//  CheapEats
//
//  Created by Emre on 22.03.2025.
//

import UIKit
import MapKit

final class DeliveryViewController: UIViewController {
    //MARK: -Variables
    @IBOutlet weak var sectionView: UIView!
    @IBOutlet weak var checkOrderView: UIView!
    @IBOutlet weak var checkOrderImageView: UIImageView!
    @IBOutlet weak var deliveryView: UIView!
    @IBOutlet weak var deliveryImageView: UIImageView!
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var paymentImageView: UIImageView!
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var oldTotalLabel: UILabel!
    @IBOutlet weak var deliveryTypeSegment: CustomSegmentedControl!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var adressLabel: UILabel!
    
    @IBOutlet weak var adressView: UIView!
    private var dashedLines: [CAShapeLayer] = []
    var deliveryViewModel: DeliveryViewModelProtocol = DeliveryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initScreen()
        initSegment()
        configureMapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        initData()
        addDashedLines()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = UIColor(named: "ButtonColor")
        
        if isMovingFromParent {
            CartViewController.isComingFromThirdVC = true
        }
    }
    
    private func initScreen() {
        deliveryViewModel.delegate = self
        
        deliveryView.layer.cornerRadius = deliveryView.frame.size.width / 2
        paymentView.layer.cornerRadius = paymentView.frame.size.width / 2
        checkOrderView.layer.cornerRadius = checkOrderView.frame.size.width / 2
        checkOrderImageView.layer.cornerRadius = 5
        deliveryImageView.layer.cornerRadius = 5
        paymentImageView.layer.cornerRadius = 5
        checkOrderImageView.layer.masksToBounds = true
        deliveryImageView.layer.masksToBounds = true
        paymentImageView.layer.masksToBounds = true
        totalView.layer.cornerRadius = 5
        setShadow(with: totalView.layer, shadowOffset: true)
        nextButton.layer.cornerRadius = 5
        mapView.layer.cornerRadius = 5
        setShadow(with:mapView.layer, shadowOffset: true)
        setShadow(with: adressView.layer, shadowOffset: true)
        adressView.layer.cornerRadius = 5
    }
    
    private func initData() {
        totalLabel.text = "\(formatDouble(deliveryViewModel.totalAmount)) TL"
        oldTotalLabel.text = "\(formatDouble(deliveryViewModel.oldTotalAmount)) TL"
    }
    
    private func initSegment() {
        deliveryTypeSegment.setSecondaryText("(Ekstra 20TL)", forSegmentAt: 0)
        deliveryViewModel.distanceCalculate { distance in
            self.deliveryTypeSegment.setSecondaryText("(\(distance))", forSegmentAt: 1)
        }
        
        deliveryViewModel.deliveryType(deliveryTypeSegment)
    }
    
    private func configureMapView() {
        mapView.delegate = self
        mapView.showsCompass = false
        mapView.showsScale = false
        mapView.showsTraffic = false
        mapView.showsBuildings = false
        mapView.showsLargeContentViewer = false
        mapView.pointOfInterestFilter = MKPointOfInterestFilter(including: MKPointOfInterestCategory.defaultCategoriesToShow)
        deliveryViewModel.mapViewCenterCoordinate(mapView: mapView)
        
        adressLabel.text = deliveryViewModel.getAdress()
    }
    
    private func addDashedLines() {
        guard let checkImage = checkOrderView, let deliveryImage = deliveryView, let paymentImage = paymentView else { return }
        let imageViews = [checkImage, deliveryImage, paymentImage]
        
        dashedLines = DashedLineManager.shared.createDashedLinesBetweenImages(
            imageViews: imageViews,
            in: sectionView,
            animateIndices: [1,2],
            lineWidth: 2.0,
            dashPattern: [6, 3],
            fromColor: .title,
            toColor: .button,
            animationDuration: 1,
            padding: 8
        )
        
    }
    
    @IBAction func deliverySegmentClicked(_ sender: CustomSegmentedControl) {
        print(sender.selectedSegmentIndex)
    }
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        
    }
    
}

extension DeliveryViewController: DeliveryViewModelOutputProtocol {
    func update() {
        print("update")
    }
    
    func error() {
        print("error")
    }
}
