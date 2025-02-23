//
//  AddCardViewController.swift
//  CheapEats
//
//  Created by Emre on 23.02.2025.
//

import UIKit

final class AddCardViewController: UIViewController {
    //MARK: -Variables
    var addcardViewModel: AddCardViewModelProtocol = AddCardViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        addcardViewModel.delegate = self
        print("AddCardViewController")
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
