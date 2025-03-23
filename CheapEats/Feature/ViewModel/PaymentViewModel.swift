//
//  PaymentViewModel.swift
//  CheapEats
//
//  Created by Emre on 23.03.2025.
//

protocol PaymentViewModelProtocol {
    var delegate: PaymentViewModelOutputProtocol? { get set }
    var orderDetail: OrderDetail? { get set }
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
}

extension PaymentViewModel: PaymentViewModelProtocol {}


