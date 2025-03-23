//
//  PaymentViewController.swift
//  CheapEats
//
//  Created by Emre on 23.03.2025.
//

import UIKit
import JVFloatLabeledTextField

final class PaymentViewController: UIViewController {
    //MARK: -Variables
    @IBOutlet weak var scrollView: UIScrollView!
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
    @IBOutlet weak var okayButton: UIButton!
    
    @IBOutlet weak var cardInfoView: UIView!
    @IBOutlet weak var changePayButton: UIButton!
    @IBOutlet weak var cardOwnerNameTextField: JVFloatLabeledTextField!
    @IBOutlet weak var cardNoTextField: JVFloatLabeledTextField!
    @IBOutlet weak var cardMonthTextField: JVFloatLabeledTextField!
    @IBOutlet weak var cardYearTextField: JVFloatLabeledTextField!
    @IBOutlet weak var cardCVVTextField: JVFloatLabeledTextField!
    @IBOutlet weak var cardNameTextField: JVFloatLabeledTextField!
    @IBOutlet weak var cardInfoViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var saveCardSwitch: UISwitch!
    
    private var dashedLines: [CAShapeLayer] = []
    var paymentViewModel: PaymentViewModelProtocol = PaymentViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        addStaticDashedLines()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = UIColor(named: "ButtonColor")
        
        if isMovingFromParent {
            DeliveryViewController.isComingFromPaymentVC = true
        }
    }
    
    private func initScreen() {
        paymentViewModel.delegate = self
        
        deliveryView.layer.cornerRadius = deliveryView.frame.size.width / 2
        paymentView.layer.cornerRadius = paymentView.frame.size.width / 2
        checkOrderView.layer.cornerRadius = checkOrderView.frame.size.width / 2
        checkOrderImageView.layer.masksToBounds = true
        deliveryImageView.layer.masksToBounds = true
        paymentImageView.layer.masksToBounds = true
        checkOrderImageView.layer.cornerRadius = 5
        deliveryImageView.layer.cornerRadius = 5
        paymentImageView.layer.cornerRadius = 5
        totalView.layer.cornerRadius = 5
        setShadow(with: totalView.layer, shadowOffset: true)
        okayButton.layer.cornerRadius = 5
        
        cardInfoView.layer.cornerRadius = 5
        setShadow(with: cardInfoView.layer, shadowOffset: true)
        addHorizontalLine(toView: cardInfoView, belowView: changePayButton)
    }
    
    private func addStaticDashedLines() {
        guard let checkImage = checkOrderView, let deliveryImage = deliveryView, let paymentImage = paymentView else { return }
        let imageViews = [checkImage, deliveryImage, paymentImage]
        
        dashedLines = DashedLineManager.shared.createNonAnimatedDashedLinesBetweenImages(
            imageViews: imageViews,
            in: sectionView,
            selectedIndices: [0,1,2],
            lineWidth: 2.0,
            dashPattern: [6, 3],
            defaultColor: .lightGray,
            selectedColor: .button,
            padding: 8
        )
    }
    
    @IBAction func okayButtonClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func changePayButton(_ sender: UIButton) {
    }
    
    @IBAction func saveCardSwitchChanged(_ sender: UISwitch) {
        let newHeight: CGFloat = sender.isOn ? 300 : 250
        
        if !sender.isOn {
            self.cardNameTextField.isHidden = true
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.cardInfoViewHeightConstraint.constant = newHeight
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.setShadow(with: self.cardInfoView.layer, shadowOffset: true)
            if sender.isOn {
                self.cardNameTextField.isHidden = false
            }
        })
    }
}

extension PaymentViewController: PaymentViewModelOutputProtocol {
    func update() {
        print("update")
    }
    
    func error() {
        print("error")
    }
    
    func startLoading() {
        print("startLoading")
    }
    
    func stopLoading() {
        print("stopLoading")
    }
}
