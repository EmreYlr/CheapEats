//
//  ManageCardViewController.swift
//  CheapEats
//
//  Created by Emre on 22.02.2025.
//

import UIKit

final class ManageCardViewController: UIViewController {
    //MARK: -Variables
    var manageCardViewModel: ManageCardViewModelProtocol = ManageCardViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Manage Card View Controller")
    }
}
