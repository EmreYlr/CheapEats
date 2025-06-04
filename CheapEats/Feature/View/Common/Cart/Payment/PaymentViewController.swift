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
    @IBOutlet weak var couponView: UIView!
    @IBOutlet weak var couponCodeTextField: JVFloatLabeledTextField!
    @IBOutlet weak var couponButton: UIButton!
    @IBOutlet weak var couponInfoLabel: UILabel!
    @IBOutlet weak var payDetailView: UIView!
    @IBOutlet weak var payDetailLabel: UILabel!
    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var newPriceLabel: UILabel!
    @IBOutlet weak var payDetailTotalLabel: UILabel!
    @IBOutlet weak var takeoutLabel: UILabel!
    @IBOutlet weak var couponLabel: UILabel!
    @IBOutlet weak var couponPriceLabel: UILabel!
    @IBOutlet weak var paymentStackView: UIStackView!
    
    var isOpen = false
    private var dashedLines: [CAShapeLayer] = []
    var paymentViewModel: PaymentViewModelProtocol = PaymentViewModel() 
    let SB = UIStoryboard(name: "Main", bundle: nil)
    private var cardSelectViewController: CardSelectViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initScreen()
        initData()
        couponCodeTextField.addTarget(self, action: #selector(couponTextFieldDidChange(_:)), for: .editingChanged)
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
    
    private func initData() {
        oldTotalLabel.text = "\(formatDouble(paymentViewModel.oldTotalAmount)) TL"
        oldPriceLabel.text = "\(formatDouble(paymentViewModel.oldTotalAmount)) TL"
        discountLabel.text = "\(formatDouble(paymentViewModel.totalAmount - paymentViewModel.oldTotalAmount)) TL"
        newPriceLabel.text = "\(formatDouble(paymentViewModel.totalAmount)) TL"
        
        if paymentViewModel.takeoutPrice > 0 {
            takeoutLabel.isHidden = false
            takeoutLabel.text = "(Kurye Ücreti: \(formatDouble(paymentViewModel.takeoutPrice)) TL)"
            payDetailTotalLabel.text = "\(formatDouble(paymentViewModel.totalAmount + paymentViewModel.takeoutPrice)) TL"
            totalLabel.text = "\(formatDouble(paymentViewModel.totalAmount + paymentViewModel.takeoutPrice)) TL"
            paymentViewModel.totalAmount = paymentViewModel.totalAmount + paymentViewModel.takeoutPrice
        } else {
            takeoutLabel.isHidden = true
            payDetailTotalLabel.text = "\(formatDouble(paymentViewModel.totalAmount)) TL"
            totalLabel.text = "\(formatDouble(paymentViewModel.totalAmount)) TL"
            
        }
        
    }
}

//MARK: -BUTTON
extension PaymentViewController {
    @IBAction func okayButtonClicked(_ sender: UIButton) {
        guard !isOpen else {
            paymentViewModel.setOrder(isSaveCard: false, cardName: "")
            return
        }
        
        guard
            let cardOwner = cardOwnerNameTextField.text, !cardOwner.isEmpty,
            let cardNumber = cardNoTextField.text, !cardNumber.isEmpty,
            let cardMonthText = cardMonthTextField.text, let cardMonth = Int(cardMonthText),
            let cardYearText = cardYearTextField.text, let cardYear = Int(cardYearText),
            let cardCVVText = cardCVVTextField.text, let cardCVV = Int(cardCVVText)
        else {
            showOneButtonAlert(title: "Hata", message: "Lütfen tüm kart bilgilerini doğru formatta doldurun.")
            return
        }

        let creditCard = UserCreditCards(
            cardName: "",
            cardOwnerName: cardOwner,
            cardNo: cardNumber,
            cardMonth: cardMonth,
            cardYear: cardYear,
            CVV: cardCVV,
            cardType: determineCardType(cardNumber: cardNumber)
        )

        paymentViewModel.creditCart = creditCard

        if saveCardSwitch.isOn {
            guard let cardName = cardNameTextField.text, !cardName.isEmpty else {
                showOneButtonAlert(title: "Hata", message: "Lütfen kartı kayıt etmek için kart ismi giriniz.")
                return
            }
            paymentViewModel.setOrder(isSaveCard: true, cardName: cardName)
        } else {
            paymentViewModel.setOrder(isSaveCard: false, cardName: "")
        }        
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
    
    @IBAction func couponButtonClicked(_ sender: UIButton) {
        if sender.backgroundColor == .cut {
            couponCodeTextField.text = ""
            couponButton.titleLabel?.text = "Kuponu Kodunu Onayla"
            couponButton.backgroundColor = .button
            UIView.animate(withDuration: 0.3) {
                self.couponLabel.isHidden = true
                self.couponPriceLabel.isHidden = true
            }
            payDetailTotalLabel.text = "\(formatDouble(paymentViewModel.totalAmount)) TL"
            totalLabel.text = "\(formatDouble(paymentViewModel.totalAmount )) TL"
            sender.isEnabled = false
        } else {
            paymentViewModel.fetchCoupon(code: couponCodeTextField.text ?? "")
        }
        
    }
    
    @objc func couponTextFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            couponButton.isEnabled = true
        } else {
            couponButton.isEnabled = false
        }
    }
}
//MARK: -UI
extension PaymentViewController {
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
        couponView.layer.cornerRadius = 5
        payDetailView.layer.cornerRadius = 5
        setShadow(with: cardInfoView.layer, shadowOffset: true)
        setShadow(with: couponView.layer, shadowOffset: true)
        setShadow(with: payDetailView.layer, shadowOffset: true)
        addHorizontalLine(toView: cardInfoView, belowView: changePayButton)
        addHorizontalLine(toView: couponView, belowView: couponInfoLabel)
        addHorizontalLine(toView: payDetailView, belowView: payDetailLabel)
        addHorizontalLine(toView: payDetailView, belowView: paymentStackView, horizontalPadding: 10)
        couponButton.roundCorners(corners: [.topRight, .bottomRight], radius: 5)
        
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
 
    private func frontCardView() {
        self.isOpen = false
        self.cardOwnerNameTextField.isHidden = false
        self.cardNoTextField.isHidden = false
        self.cardCVVTextField.isHidden = false
        self.cardYearTextField.isHidden = false
        self.cardMonthTextField.isHidden = false
        self.saveCardSwitch.isHidden = false
        self.switchLabel.isHidden = false
    }
    
    private func firstFrontCardView() {
        self.registeredCardView.isHidden = true
        self.registeredCardLabel.isHidden = true
    }
    
    private func backCardView() {
        self.isOpen = true
        self.registeredCardView.isHidden = false
        self.registeredCardLabel.isHidden = false
    }
    
    private func firstBackCardView() {
        self.cardOwnerNameTextField.isHidden = true
        self.cardNoTextField.isHidden = true
        self.cardCVVTextField.isHidden = true
        self.cardNameTextField.isHidden = true
        self.cardYearTextField.isHidden = true
        self.cardMonthTextField.isHidden = true
        self.saveCardSwitch.isHidden = true
        self.switchLabel.isHidden = true
    }
}

extension PaymentViewController: PaymentViewModelOutputProtocol {
    func update() {
        print("update")
        let SB = UIStoryboard(name: "Main", bundle: nil)
        let successVC = SB.instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
        successVC.successViewModel.orderDetail = paymentViewModel.orderDetail
        navigationController?.pushViewController(successVC, animated: true)
    }
    
    func updateCoupon() {
        if let coupon = paymentViewModel.coupon {
            couponPriceLabel.text = "-\(coupon.discountValue) TL"
            payDetailTotalLabel.text = "\(formatDouble(paymentViewModel.totalAmount - Double(coupon.discountValue))) TL"
            totalLabel.text = "\(formatDouble(paymentViewModel.totalAmount - Double(coupon.discountValue))) TL"
            
            UIView.animate(withDuration: 0.3) {
                self.couponLabel.isHidden = false
                self.couponPriceLabel.isHidden = false
            }
            
            couponButton.titleLabel?.text = "Kuponu Kaldır"
            couponButton.backgroundColor = .cut
        }
    }
    
    func error() {
        print("error")
    }
    
    func errorCoupon() {
        showOneButtonAlert(title: "Hata", message: "Girmiş olduğunuz kupon kodu hatalı")
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
        paymentViewModel.creditCart = creditCard
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
