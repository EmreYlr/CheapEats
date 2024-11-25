//
//  PassResViewController.swift
//  CheapEats
//
//  Created by Emre on 24.11.2024.
//

import UIKit

final class PassResViewController: UIViewController {
    //MARK: -Variables
    @IBOutlet weak var emailLayer: UITextField!
    var passResViewModel: PassResViewModelProtocol = PassResViewModel()
    @IBOutlet weak var passResButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        passResViewModel.delegate = self
        passResButton.layer.cornerRadius = 10
    }
    
    @IBAction func passResButtonClicked(_ sender: Any) {
        guard let email = emailLayer.text else { return }
        passResViewModel.resetPassword(email: email)
    }
}

extension PassResViewController: PassResViewModelOutputProtocol {
    func update() {
        print("update")
    }
    
    func error() {
        print("error")
    }
}
