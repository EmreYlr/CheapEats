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
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var registeredCardView: UIView!
    @IBOutlet weak var registeredCardLabel: UILabel!
    @IBOutlet weak var registeredCardButton: UIButton!
    @IBOutlet weak var registeredCardImage: UIImageView!
    var isOpen = false
    private var dashedLines: [CAShapeLayer] = []
    var paymentViewModel: PaymentViewModelProtocol = PaymentViewModel()
    
    let SB = UIStoryboard(name: "Main", bundle: nil)
    private var cardSelectViewController: CardSelectViewController?
    
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
        registeredCardView.layer.cornerRadius = 5
        setBorder(with: registeredCardView.layer)

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
        let newHeight: CGFloat = isOpen ? 250 : 150
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 13)]
        if isOpen {
            UIView.animate(withDuration: 0.3, animations: {
                let attributedTitle = NSAttributedString(string: "Kayıtlı kartımla öde", attributes: attributes)
                    sender.setAttributedTitle(attributedTitle, for: .normal)
                self.cardInfoViewHeightConstraint.constant = newHeight
                self.view.layoutIfNeeded()
                self.firstFrontCardView()
            },  completion: { _ in
                self.frontCardView()
            })
        }else{
            sender.titleLabel?.font = .systemFont(ofSize: 13)
            UIView.animate(withDuration: 0.3, animations: {
                self.cardInfoViewHeightConstraint.constant = newHeight
                let attributedTitle = NSAttributedString(string: "Başka Kartla Öde", attributes: attributes)
                    sender.setAttributedTitle(attributedTitle, for: .normal)
                self.view.layoutIfNeeded()
                self.firstBackCardView()
            },  completion: { _ in
                self.backCardView()
            })
        }
    }
    
    func frontCardView() {
        self.isOpen = false
        self.cardOwnerNameTextField.isHidden = false
        self.cardNoTextField.isHidden = false
        self.cardCVVTextField.isHidden = false
        self.cardYearTextField.isHidden = false
        self.cardMonthTextField.isHidden = false
        self.saveCardSwitch.isHidden = false
        self.switchLabel.isHidden = false
    }
    
    func firstFrontCardView() {
        self.registeredCardView.isHidden = true
        self.registeredCardLabel.isHidden = true
    }
    
    func backCardView() {
        self.isOpen = true
        self.registeredCardView.isHidden = false
        self.registeredCardLabel.isHidden = false
    }
    
    func firstBackCardView() {
        self.cardOwnerNameTextField.isHidden = true
        self.cardNoTextField.isHidden = true
        self.cardCVVTextField.isHidden = true
        self.cardNameTextField.isHidden = true
        self.cardYearTextField.isHidden = true
        self.cardMonthTextField.isHidden = true
        self.saveCardSwitch.isHidden = true
        self.switchLabel.isHidden = true
    }
    
    @IBAction func saveCardSwitchChanged(_ sender: UISwitch) {
        let newHeight: CGFloat = sender.isOn ? 300 : 250
        
        if !sender.isOn {
            self.cardNameTextField.isHidden = true
            self.cardNameTextField.isEnabled = false
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.cardInfoViewHeightConstraint.constant = newHeight
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.setShadow(with: self.cardInfoView.layer, shadowOffset: true)
            if sender.isOn {
                self.cardNameTextField.isHidden = false
                self.cardNameTextField.isEnabled = true
                self.cardNameTextField.becomeFirstResponder()
            }
        })
    }
    @IBAction func registeredCardButtonClicked(_ sender: UIButton) {
        if cardSelectViewController == nil {
            cardSelectViewController = SB.instantiateViewController(withIdentifier: "CardSelectViewController") as? CardSelectViewController
        }
        if let cardSelectVC = cardSelectViewController {
            cardSelectVC.modalPresentationStyle = .pageSheet
            if let sheet = cardSelectVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
            }
            cardSelectVC.delegate = self
            present(cardSelectVC, animated: true)
        }
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

extension PaymentViewController: CardSelectViewModelDelegate {
    func didApplySelection(selectedOption: UserCreditCards?) {
        guard let creditCard = selectedOption else { return }
        registeredCardButton.setTitle("\(creditCard.cardName) - \(creditCard.cardNo.suffix(4))", for: .normal)
        registeredCardImage.isHidden = false
        switch creditCard.cardType {
        case .visa:
            registeredCardImage.image = UIImage(named: "VisaLogo")
        case .mastercard:
            registeredCardImage.image = UIImage(named: "MCLogo")
        case .troy:
            registeredCardImage.image = UIImage(named: "troyLogo")
        case .unknown:
            registeredCardImage.isHidden = true
        }
    }
}
