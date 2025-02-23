//
//  AddCardViewController.swift
//  CheapEats
//
//  Created by Emre on 23.02.2025.
//

import UIKit

final class AddCardViewController: UIViewController {
    //MARK: -Variables
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardTypeImage: UIImageView!
    @IBOutlet weak var cardNoLabel: UILabel!
    @IBOutlet weak var cardNoTextLabel: UILabel!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardNameTextLabel: UILabel!
    @IBOutlet weak var expiryDateLabel: UILabel!
    @IBOutlet weak var expiryDateTextLabel: UILabel!
    @IBOutlet weak var cardBackView: UIView!
    @IBOutlet weak var CCVLabel: UILabel!
    @IBOutlet weak var CCVTextLabel: UILabel!
    
    var addcardViewModel: AddCardViewModelProtocol = AddCardViewModel()
    var isOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AddCardViewController")
        initScreen()
        setupGradient(with: .black)
        setupTapGesture()
    }
    private func initScreen() {
        addcardViewModel.delegate = self
        cardView.layer.cornerRadius = 10
        cardView.layer.masksToBounds = true
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
    
    @objc private func cardViewTapped() {
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
        CCVLabel.isHidden = true
        CCVTextLabel.isHidden = true
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
        CCVLabel.isHidden = false
        CCVTextLabel.isHidden = false
    }
    
}

extension AddCardViewController: AddCardViewModelOutputProtocol {
    func update() {
        print("update")
    }
    
    func error() {
        print("error")
    }
}
