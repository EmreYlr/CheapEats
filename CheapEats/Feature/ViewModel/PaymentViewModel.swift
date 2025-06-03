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
    var coupon: Coupon? { get set }
    var creditCart: UserCreditCards? { get set } 
    func fetchCoupon(code: String)
    func setOrder(isSaveCard: Bool, cardName: String)
}

protocol PaymentViewModelOutputProtocol: AnyObject {
    func update()
    func error()
    func updateCoupon()
    func errorCoupon()
    func startLoading()
    func stopLoading()
}

final class PaymentViewModel {
    weak var delegate: PaymentViewModelOutputProtocol?
    var orderDetail: OrderDetail?
    var cartItems: [ProductDetails] = []
    var coupon: Coupon?
    var creditCart: UserCreditCards?
    var totalAmount: Double = 0.0
    var oldTotalAmount: Double = 0.0
    var takeoutPrice: Double  = 0.0
    var couponStatus: Bool = false
    
    func fetchCoupon(code: String) {
        NetworkManager.shared.fetchCoupon(byCode: code) { result in
            switch result {
            case .success(let coupon):
                self.coupon = coupon
                self.delegate?.updateCoupon()
            case .failure(let error):
                print("Hata:", error.localizedDescription)
                self.delegate?.errorCoupon()
            }
        }
    }
    
    func setOrder(isSaveCard: Bool, cardName: String = "") {
        setOrderDetail()
        
        guard let order = orderDetail?.userOrder else {
            self.delegate?.error()
            return
        }
        if isSaveCard {
            saveCard(cardName: cardName)
        }

        NetworkManager.shared.addOrder(order: order) { result in
            switch result {
            case .success(let orderNo):
                print("Success")
                self.orderDetail?.userOrder.orderNo = orderNo
                self.delegate?.update()
            case.failure:
                self.delegate?.error()
            }
        }
    }
    
    private func saveCard(cardName: String) {
        guard var card = creditCart else {
            delegate?.error()
            return
        }
        card.cardName = cardName
        NetworkManager.shared.addUserCreditCard(card: card) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                print("Kart Kaydedildi")
            case .failure:
                print("Kart kaydedilerken hata oldu")
                self.delegate?.error()
            }
        }
    }
    
    private func setOrderDetail() {
        guard let cardInfo = creditCart else {
            print("Kart Atanamadı")
            delegate?.error()
            return
        }
        
        if let quantity = orderDetail?.productDetail.product.selectedCount {
            orderDetail?.userOrder.quantity = quantity
        }
        
        self.orderDetail?.userOrder.cardInfo = "\(cardInfo.cardNo.suffix(4))"
        self.orderDetail?.userOrder.couponId = coupon?.couponId ?? ""
    }
}

extension PaymentViewModel: PaymentViewModelProtocol {}


