//
//  PaymentViewModel.swift
//  CheapEats
//
//  Created by Emre on 23.03.2025.
//

protocol PaymentViewModelProtocol {
    var delegate: PaymentViewModelOutputProtocol? { get set }
    var orderDetail: OrderDetail? { get set }
    var cartItems: [ProductDetails] { get set }
    var totalAmount: Double { get set }
    var oldTotalAmount: Double { get set }
    var takeoutPrice: Double { get set }
    func fetchCoupon(code: String)
}

protocol PaymentViewModelOutputProtocol: AnyObject {
    func update()
    func error()
    func startLoading()
    func stopLoading()
}

final class PaymentViewModel {
    weak var delegate: PaymentViewModelOutputProtocol?
    var orderDetail: OrderDetail?
    var cartItems: [ProductDetails] = []
    var totalAmount: Double = 0.0
    var oldTotalAmount: Double = 0.0
    var takeoutPrice: Double  = 0.0
    
    func fetchCoupon(code: String) {
        NetworkManager.shared.fetchCoupon(byCode: code) { result in
            switch result {
            case .success(let coupon):
                print("Kupon bulundu:", coupon)
            case .failure(let error):
                print("Hata:", error.localizedDescription)
            }
        }
    }
}

extension PaymentViewModel: PaymentViewModelProtocol {}


