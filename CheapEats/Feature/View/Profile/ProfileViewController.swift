//
//  ProfileViewController.swift
//  CheapEats
//
//  Created by CANSU on 3.12.2024.
//

import Foundation
import UIKit
final class ProfileViewController: UIViewController{
    //MARK: -Variables
    @IBOutlet weak var profileView: UIView!
    @IBOutlet var emailView: UIView!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var cardManagementButton:UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    
    private let profileViewModel: ProfileViewModelProtocol = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ProfileViewModel")
        initScreen()
        
        if let user = profileViewModel.user {
            profileName.text = "\(user.firstName) \(user.lastName)"
            emailLabel.text = user.email
            phoneLabel.text = "5523439914" //TODO: - phone number
        }
    }
    
    private func initScreen() {
        configureView(profileImageView, cornerRadius: 5, borderColor: .gray, borderWidth: 0.5)
        setBorder(with: profileView.layer)
        setBorder(with: emailView.layer)
        setBorder(with: phoneView.layer)
        setBorder(with: exitButton.layer)
        setBorder(with: cardManagementButton.layer)
        setBorder(with: editProfileButton.layer)
        setShadow(with: editProfileButton.layer , shadowOffset: true)
        setShadow(with: phoneView.layer, shadowOffset: false)

    }
    
}

//MARK: -Output Protocol
extension ProfileViewController: ProfileViewModelOutputProtocol {
    func update() {
        print("update")
    }
    
    func error() {
        print("error")
    }
    
    
}
