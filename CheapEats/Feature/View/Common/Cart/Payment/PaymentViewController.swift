//
//  PaymentViewController.swift
//  CheapEats
//
//  Created by Emre on 23.03.2025.
//

import UIKit

final class PaymentViewController: UIViewController {
    //MARK: -Variables
    var paymentViewModel: PaymentViewModelProtocol = PaymentViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        initScreen()
    }
    
    private func initScreen() {
        paymentViewModel.delegate = self
        print(paymentViewModel.orderDetail?.userOrder.selectedDeliveryType)
    }

}

extension PaymentViewController: PaymentViewModelOutputProtocol {
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
