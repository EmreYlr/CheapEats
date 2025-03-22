//
//  DeliveryViewController.swift
//  CheapEats
//
//  Created by Emre on 22.03.2025.
//

import UIKit

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
    
    @IBOutlet weak var nextButton: UIButton!
    private var dashedLines: [CAShapeLayer] = []
    var deliveryViewModel: DeliveryViewModelProtocol = DeliveryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initScreen()
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
        checkOrderImageView.layer.masksToBounds = true
        deliveryImageView.layer.masksToBounds = true
        paymentImageView.layer.masksToBounds = true
        totalView.layer.cornerRadius = 5
        setShadow(with: totalView.layer, shadowOffset: true)
        nextButton.layer.cornerRadius = 5
        
    }
    
    private func initData() {
        totalLabel.text = "\(formatDouble(deliveryViewModel.totalAmount)) TL"
        oldTotalLabel.text = "\(formatDouble(deliveryViewModel.oldTotalAmount)) TL"
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
