//
//  ProfileViewController.swift
//  CheapEats
//
//  Created by CANSU on 3.12.2024.
//

import Foundation
import UIKit
final class ProfileViewController: UIViewController{

 private let profileViewModel: ProfileViewModelProtocol = ProfileViewModel()
    
    //MARK: -Variables
    
    @IBOutlet weak var ProfileBackView: UIView!
    
    
    @IBOutlet var ContentView: UIView!
    @IBOutlet weak var phoneBackView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var epostaLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var accountManagement:UIButton!
    @IBOutlet weak var editProfile: UIButton!
    @IBOutlet weak var exitLbl: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var emailBackView: UIView!
    override func viewDidLoad() {
    super.viewDidLoad()
    print("ProfileViewModel ")
    initScreen()
}
    //MARK: -Func
private func initScreen() {
    ProfileBackView.roundCorners(corners: [.topRight,.bottomLeft], radius: 30, borderColor: UIColor(named: "TitleColor"), borderWidth: 4)
  ContentView.roundCorners(corners: [.allCorners], radius: 15, borderColor: UIColor(named: "TitleColor"), borderWidth: 2)
   // phoneBackView.roundCorners(corners: [.allCorners], radius: 13, borderColor: UIColor(named: "TitleColor"), borderWidth: 1)
    epostaLbl.roundCorners(corners: [.allCorners], radius: 5, borderColor: UIColor(named: "TitleColor"), borderWidth: 1)
    phoneLbl.roundCorners(corners: [.allCorners], radius: 5, borderColor: UIColor(named: "TitleColor"), borderWidth: 1)
    profileImageView.roundCorners(corners: [.allCorners], radius: 20, borderColor: UIColor(named: "TitleColor"), borderWidth: 1)
    profileName.roundCorners(corners: [.allCorners], radius: 5, borderColor: UIColor(named: "TitleColor"), borderWidth: 1)
    editProfile.roundCorners(corners: [.allCorners], radius: 10, borderColor: UIColor(named: "TitleColor"), borderWidth: 1)
    accountManagement.roundCorners(corners: [.allCorners], radius: 10, borderColor: UIColor(named: "TitleColor"), borderWidth: 1)
    exitLbl.roundCorners(corners: [.allCorners], radius: 10, borderColor: UIColor(named: "CutColor"), borderWidth: 1)
    
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
