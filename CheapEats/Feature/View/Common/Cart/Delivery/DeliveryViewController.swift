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
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressStateLabel: UILabel!
    @IBOutlet weak var deliveryWarningLabel: UILabel!
    @IBOutlet weak var deliveryStateLabel: UILabel!
    
    private var dashedLines: [CAShapeLayer] = []
    static var isComingFromPaymentVC: Bool = false
    var deliveryViewModel: DeliveryViewModelProtocol = DeliveryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapView()
        initScreen()
        initSegment()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        initData()
        if DeliveryViewController.isComingFromPaymentVC {
            DeliveryViewController.isComingFromPaymentVC = false
            addStaticDashedLines()
        } else {
            //
            addDashedLines()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = UIColor(named: "ButtonColor")
        
        if isMovingFromParent {
            CartViewController.isComingFromDeliveryVC = true
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
        totalView.layer.cornerRadius = 5
        nextButton.layer.cornerRadius = 5
        mapView.layer.cornerRadius = 5
        addressView.layer.cornerRadius = 5
        
        checkOrderImageView.layer.masksToBounds = true
        deliveryImageView.layer.masksToBounds = true
        paymentImageView.layer.masksToBounds = true
        
        setShadow(with: totalView.layer, shadowOffset: true)
        setShadow(with: addressView.layer, shadowOffset: true)
    }
    
    private func initData() {
        oldTotalLabel.text = "\(formatDouble(deliveryViewModel.oldTotalAmount)) TL"
    }
    
    private func initSegment() {
        deliveryTypeSegment.setSecondaryText("(Ekstra 20TL)", forSegmentAt: 0)
        deliveryViewModel.distanceCalculate { distance in
            self.deliveryTypeSegment.setSecondaryText("(\(distance))", forSegmentAt: 1)
        }
        
        deliveryViewModel.deliveryType(deliveryTypeSegment, mapView: mapView, addressLabel: addressLabel, addressStateLabel: addressStateLabel, totalAmount: totalLabel, deliveryWarningLabel: deliveryWarningLabel, deliveryStateLabel: deliveryStateLabel)
    }
    
    private func configureMapView() {
        mapView.delegate = self
        mapView.showsCompass = false
        mapView.showsScale = false
        mapView.showsTraffic = false
        mapView.showsBuildings = false
        mapView.showsLargeContentViewer = false
        mapView.pointOfInterestFilter = MKPointOfInterestFilter(including: MKPointOfInterestCategory.defaultCategoriesToShow)
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
    
    private func addStaticDashedLines() {
        guard let checkImage = checkOrderView, let deliveryImage = deliveryView, let paymentImage = paymentView else { return }
        let imageViews = [checkImage, deliveryImage, paymentImage]
        
        dashedLines = DashedLineManager.shared.createNonAnimatedDashedLinesBetweenImages(
            imageViews: imageViews,
            in: sectionView,
            selectedIndices: [1,2],
            lineWidth: 2.0,
            dashPattern: [6, 3],
            defaultColor: .title,
            selectedColor: .button,
            padding: 8
        )
    }
    
    @IBAction func deliverySegmentClicked(_ sender: CustomSegmentedControl) {
        deliveryViewModel.selectedDeliveryType(at: sender.selectedSegmentIndex, mapView: mapView, addressLabel: addressLabel, addressStateLabel: addressStateLabel, totalAmount: totalLabel, deliveryWarningLabel: deliveryWarningLabel, deliveryStateLabel: deliveryStateLabel) 
    }
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        deliveryViewModel.createOrder(at: deliveryTypeSegment.selectedSegmentIndex)
    }
    
}

extension DeliveryViewController: DeliveryViewModelOutputProtocol {
    func update() {
        let SB = UIStoryboard(name: "Main", bundle: nil)
        let paymentVC = SB.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
        paymentVC.paymentViewModel.orderDetail = deliveryViewModel.orderDetail
        paymentVC.paymentViewModel.cartItems = deliveryViewModel.cartItems
        paymentVC.paymentViewModel.totalAmount = deliveryViewModel.totalAmount
        paymentVC.paymentViewModel.oldTotalAmount = deliveryViewModel.oldTotalAmount
        paymentVC.paymentViewModel.takeoutPrice = deliveryViewModel.takeoutPrice
        navigationController?.pushViewController(paymentVC, animated: true)
    }
    
    func error() {
        print("error")
    }
}
