//
//  CartViewController.swift
//  CheapEats
//
//  Created by Emre on 11.03.2025.
//

import UIKit

final class CartViewController: UIViewController {
    //MARK: -Variables
    var cartViewModel: CartViewModelProtocol = CartViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        initScreen()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        // Sepet verilerini yenileme
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = UIColor(named: "ButtonColor")
    }
    
    func initScreen() {
        cartViewModel.delegate = self
    }
}

extension CartViewController: CartViewModelOutputProtocol {
    func update() {
        print("update")
    }
    
    func error() {
        print("error")
    }
    
    func startLoading() {
        print("startLoading")
    }
    
    func stopLoading() {
        print("stopLoading")
    }
    
    
}
