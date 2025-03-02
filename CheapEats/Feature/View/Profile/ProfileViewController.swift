//
//  ProfileViewController.swift
//  CheapEats
//
//  Created by CANSU on 3.12.2024.
//

import Foundation
import UIKit
import NVActivityIndicatorView

final class ProfileViewController: UIViewController {
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
    @IBOutlet weak var waitView: UIView!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    private var loadIndicator: NVActivityIndicatorView!
    let SB = UIStoryboard(name: "Main", bundle: nil)
    private var profileViewModel: ProfileViewModelProtocol = ProfileViewModel()
    private var manageCardViewController: ManageCardViewController?
    private var editProfileViewController: EditProfileViewController?
    private var changePasswordViewController: ChangePasswordViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ProfileViewModel")
        initScreen()
        setupLoadingIndicator()
        updateUserInfo()
        NotificationCenter.default.addObserver(self, selector: #selector(userProfileUpdated), name: NSNotification.Name("UserProfileUpdated"), object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func userProfileUpdated() {
        profileViewModel.refreshUserData()
        updateUserInfo()
        showOneButtonAlert(title: "Uyarı", message: "İşleminiz başarılı bir şekilde gerçekleştirildi.")
    }
    private func setupLoadingIndicator() {
        loadIndicator = createLoadingIndicator(in: waitView)
    }
    
    private func updateUserInfo() {
        if let user = profileViewModel.user {
            profileName.text = "\(user.firstName) \(user.lastName)"
            emailLabel.text = user.email
            phoneLabel.text = user.phoneNumber
        }
    }
    
    private func initScreen() {
        profileViewModel.delegate = self
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
    
    @IBAction func editProfileButtonClicked(_ sender: UIButton) {
        if editProfileViewController == nil {
            editProfileViewController = SB.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController
        }
        if let editProfileVC = editProfileViewController {
            navigationController?.pushViewController(editProfileVC, animated: true)
        }
    }
    
    @IBAction func changePasswordButton(_ sender: UIButton) {
        if changePasswordViewController == nil {
            changePasswordViewController = SB.instantiateViewController(withIdentifier: "ChangePasswordViewController") as? ChangePasswordViewController
        }
        if let changePasswordVC = changePasswordViewController {
            navigationController?.pushViewController(changePasswordVC, animated: true)
        }
    }
    
    @IBAction func manageCardButtonClicked(_ sender: UIButton) {
        if manageCardViewController == nil {
            manageCardViewController = SB.instantiateViewController(withIdentifier: "ManageCardViewController") as? ManageCardViewController
        }
        if let manageCardVC = manageCardViewController {
            navigationController?.pushViewController(manageCardVC, animated: true)
        }
    }
    
    @IBAction func signOutButtonClicked(_ sender: UIButton) {
        showTwoButtonAlert(title: "Uyarı", message: "Çıkış yapmak istediğinizden emin misiniz?", firstButtonTitle: "İptal", firstButtonHandler: .none, secondButtonTitle: "Çıkış Yap", secondButtonHandler: { _ in
            self.profileViewModel.signOut()
        })
    }
}

//MARK: -Output Protocol
extension ProfileViewController: ProfileViewModelOutputProtocol {
    func update() {
        let SB = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = SB.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let navigationController = UINavigationController(rootViewController: loginViewController)
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window?.layer.add(transition, forKey: kCATransition)
        self.view.window?.rootViewController = navigationController
        self.view.window?.makeKeyAndVisible()
    }
    
    func error() {
        print("error")
    }
    
    func startLoading() {
        waitView.isHidden = false
        waitView.alpha = 0.4
        loadIndicator.isHidden = false
        loadIndicator.startAnimating()
    }
    
    func stopLoading() {
        waitView.isHidden = true
        loadIndicator.isHidden = true
        loadIndicator.stopAnimating()
    }
    
    
}
