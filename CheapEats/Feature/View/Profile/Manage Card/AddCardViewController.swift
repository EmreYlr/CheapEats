//
//  AddCardViewController.swift
//  CheapEats
//
//  Created by Emre on 23.02.2025.
//

import UIKit

final class AddCardViewController: UIViewController{
    //MARK: -Variables
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardInfoView: UIView!
    @IBOutlet weak var cardTypeImage: UIImageView!
    @IBOutlet weak var cardNoLabel: UILabel!
    @IBOutlet weak var cardNoTextLabel: UILabel!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardNameTextLabel: UILabel!
    @IBOutlet weak var expiryDateLabel: UILabel!
    @IBOutlet weak var expiryDateTextLabel: UILabel!
    @IBOutlet weak var cardBackView: UIView!
    @IBOutlet weak var CVVLabel: UILabel!
    @IBOutlet weak var CVVTextLabel: UILabel!
    @IBOutlet weak var cardNoTextField: UITextField!
    @IBOutlet weak var cardOwnerNameTextField: UITextField!
    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var CVVTextField: UITextField!
    @IBOutlet weak var cardNameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    var addcardViewModel: AddCardViewModelProtocol = AddCardViewModel()
    var isOpen = false
    weak var delegate: AddCardViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AddCardViewController")
        initScreen()
        setupGradient(with: .black)
        setupTapGesture()
        initCardSettings()
    }
    
    private func initCardSettings() {
        cardNoTextField.delegate = self
        cardOwnerNameTextField.delegate = self
        monthTextField.delegate = self
        yearTextField.delegate = self
        cardNoTextLabel.textColor = .gray
        CVVTextField.delegate = self
        cardNoTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        monthTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        yearTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        cardOwnerNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        CVVTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func initScreen() {
        addcardViewModel.delegate = self
        cardView.layer.cornerRadius = 10
        cardView.layer.masksToBounds = true
        saveButton.layer.cornerRadius = 5
        setShadow(with: cardInfoView.layer, shadowOffset: true)
        
    }
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        if !isValidCardNumber(cardNoTextLabel.text ?? "") {
            showOneButtonAlert(title: "Hata", message: "Girmiş olduğunuz kart numarası geçersiz.")
            return
        }
        if let userId = UserManager.shared.user?.uid {
            let userCreditCard = UserCreditCards(userId: userId, cardName: cardNameTextField.text ?? "", cardOwnerName: cardOwnerNameTextField.text ?? "", cardNo: cardNoTextField.text ?? "", cardMonth: Int(monthTextField.text ?? "") ?? 0, cardYear: Int(yearTextField.text ?? "") ?? 0, CVV: Int(CVVTextField.text ?? "") ?? 0, cardType: determineCardType(cardNumber: cardNoTextField.text ?? ""))
            addcardViewModel.addCard(userCreditCart: userCreditCard)
        }
    }
    
    private func setupGradient(with color: UIColor, status: Bool = true) {
        cardView.layer.sublayers?.forEach { layer in
            if layer is CAGradientLayer {
                layer.removeFromSuperlayer()
            }
        }
        let gradient = CAGradientLayer()
        gradient.type = .axial
        if status {
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        }else{
            gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        }
        
        gradient.colors = [color.withAlphaComponent(0.9).cgColor,
                           color.withAlphaComponent(0.8).cgColor,
                           color.withAlphaComponent(0.6).cgColor]
        gradient.cornerRadius = cardView.layer.cornerRadius
        gradient.frame = cardView.bounds
        cardView.layer.insertSublayer(gradient, at: 0)
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardViewTapped))
        cardView.addGestureRecognizer(tapGesture)
        cardView.isUserInteractionEnabled = true
    }
    
    @objc func cardViewTapped() {
        if isOpen {
            UIView.transition(with: cardView, duration: 0.4, options: .transitionFlipFromLeft, animations: {
                self.isOpen = false
                self.setupGradient(with: .black, status: true)
                self.frontCardView()
            }, completion: nil)
        }else{
            UIView.transition(with: cardView, duration: 0.4, options: .transitionFlipFromRight, animations: {
                self.isOpen = true
                self.setupGradient(with: .black, status: false)
                self.backCardView()
            }, completion: nil)
        }
    }
    
    func frontCardView() {
        cardTypeImage.isHidden = false
        cardNoLabel.isHidden = false
        cardNoTextLabel.isHidden = false
        cardNameLabel.isHidden = false
        cardNameTextLabel.isHidden = false
        expiryDateLabel.isHidden = false
        expiryDateTextLabel.isHidden = false
        cardBackView.isHidden = true
        CVVLabel.isHidden = true
        CVVTextLabel.isHidden = true
    }
    
    func backCardView() {
        cardTypeImage.isHidden = true
        cardNoLabel.isHidden = true
        cardNoTextLabel.isHidden = true
        cardNameLabel.isHidden = true
        cardNameTextLabel.isHidden = true
        expiryDateLabel.isHidden = true
        expiryDateTextLabel.isHidden = true
        cardBackView.isHidden = false
        CVVLabel.isHidden = false
        CVVTextLabel.isHidden = false
    }
    
}

extension AddCardViewController: AddCardViewModelOutputProtocol {
    func didAddCard(_ card: UserCreditCards) {
        print("update")
        //showOneButtonAlert(title: "Başarılı", message: "Kart başarılı bir şekilde eklendi.")
        delegate?.didAddCard(card)
        navigationController?.popViewController(animated: true)
    }
    
    func error() {
        print("error")
    }
}

protocol AddCardViewControllerDelegate: AnyObject {
    func didAddCard(_ card: UserCreditCards)
}
