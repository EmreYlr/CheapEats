//
//  PassResViewController.swift
//  CheapEats
//
//  Created by Emre on 24.11.2024.
//

import UIKit
import JVFloatLabeledTextField

final class PassResViewController: UIViewController {
    //MARK: -Variables
    @IBOutlet weak var emailLayer: JVFloatLabeledTextField!
    var passResViewModel: PassResViewModelProtocol = PassResViewModel()
    @IBOutlet weak var passResButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initScreen()
    }
    
    private func initScreen() {
        passResViewModel.delegate = self
        passResButton.layer.cornerRadius = 10
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = UIColor(named: "ButtonColor")
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
