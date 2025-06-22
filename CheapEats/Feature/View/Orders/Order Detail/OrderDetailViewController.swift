//
//  OrdersDetailViewController.swift
//  CheapEats
//
//  Created by CANSU on 1.12.2024.
//

import Foundation
import UIKit
import Kingfisher

final class OrderDetailViewController: UIViewController{
    //MARK: -Variables
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var orderDetailView: UIView!
    @IBOutlet weak var orderDetailExtView: UIView!
    @IBOutlet weak var adressDetailView: UIView!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var orderStatusLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var couponStateLabel: UILabel!
    @IBOutlet weak var paymentDetailView: CustomLineView!
    @IBOutlet weak var oldAmountLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var couponLabel: UILabel!
    @IBOutlet weak var newAmountLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var orderNo: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var pickupLocationButton: UIButton!
    
    @IBOutlet weak var deliveryTypeLabel: UILabel!
    var orderDetailViewModel: OrderDetailViewModelProtocol = OrderDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("OrdersDetailViewController ")
        initConfigureView()
        initScreen()
        orderDetailViewModel.getCoupon()
        checkDeliveryType()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = UIColor(named: "ButtonColor")
    }
    
    @objc func savePdfButtonTapped() {
        guard let pdfData = orderDetailViewModel.createPdfData(from: self.view) else {
            print("PDF oluşturulamadı")
            return
        }
        let fileName = "\(orderDetailViewModel.order?.userOrder.orderNo ?? "")-ProductDetail.pdf"
        orderDetailViewModel.savePdf(data: pdfData, fileName: fileName) { [weak self] fileURL in
            guard let self = self else { return }
            if let fileURL = fileURL {
                let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
                self.present(activityViewController, animated: true, completion: nil)
            } else {
                print("PDF kaydedilemedi")
            }
        }
    }

    private func initConfigureView() {
        scrollView.delegate = self
        configureView(detailImageView, cornerRadius: 5, borderColor: .gray, borderWidth: 0.5)
        configureView(orderDetailView, cornerRadius: 5)
        configureView(orderDetailExtView, cornerRadius: 5)
        configureView(adressDetailView, cornerRadius: 5)
        configureView(paymentDetailView, cornerRadius: 5)
        setBorder(with: orderDetailView.layer)
        setBorder(with: orderDetailExtView.layer)
        setBorder(with: adressDetailView.layer)
        setBorder(with: paymentDetailView.layer)
        setShadow(with: orderDetailExtView.layer , shadowOffset: true)
        setShadow(with: orderDetailView.layer, shadowOffset: false)
        setShadow(with: adressDetailView.layer, shadowOffset: true)
        setShadow(with: paymentDetailView.layer, shadowOffset: true)
        paymentDetailView.lineYPosition = totalLabel.frame.origin.y - 10
        paymentDetailView.setNeedsDisplay()
        pickupLocationButton.layer.cornerRadius = 5
    }
    
    private func initScreen() {
        orderDetailViewModel.delegate = self
        let saveAsPdfButton = UIBarButtonItem(title: "Save as PDF", style: .plain, target: self, action: #selector(savePdfButtonTapped))
        navigationItem.rightBarButtonItem = saveAsPdfButton
        
        if let order = orderDetailViewModel.order {
            detailImageView.kf.indicatorType = .activity
            detailImageView.kf.setImage(with: URL(string: order.productDetail.product.imageUrl))
            companyLabel.text = "\(order.productDetail.restaurant.companyName)"
            foodLabel.text = "\(order.productDetail.product.name)"
            totalPriceLabel.text = "\(formatDouble(order.productDetail.product.newPrice)) TL"
            orderNo.text = "#\(order.userOrder.orderNo)"
            dateLabel.text = "\(dateFormatter(with: order.userOrder.orderDate))"
            orderStatusLabel.text = "\(order.userOrder.status)"
            switch order.userOrder.status {
            case .pending:
                orderStatusLabel.textColor = .systemGray
            case .preparing:
                orderStatusLabel.textColor = .systemOrange
            case .ready:
                orderStatusLabel.textColor = .title
            case .delivered:
                orderStatusLabel.textColor = .button
            case .canceled:
                orderStatusLabel.textColor = .cut
            }
            cardNumberLabel.text = "**** **** **** \(order.userOrder.cardInfo)"
            let oldAmount = Double(order.productDetail.product.oldPrice)
            let newAmount = Double(order.productDetail.product.newPrice)
            oldAmountLabel.text = "\(formatDouble((Double(order.userOrder.quantity) * order.productDetail.product.oldPrice))) TL"
            discountLabel.text = "-\(formatDouble((Double(order.userOrder.quantity) * (oldAmount - newAmount)))) TL"
            newAmountLabel.text = "\( (formatDouble(Double(order.userOrder.quantity) * order.productDetail.product.newPrice))) TL"
            totalLabel.text = "\(formatDouble((Double(order.userOrder.quantity) * newAmount))) TL"
            adressLabel.text = "Adres: \(order.productDetail.restaurant.address)"
            phoneNumberLabel.text = "\(order.productDetail.restaurant.phone)"
        }
    }
    
    @IBAction func pickupLocationButton(_ sender: UIButton) {
        orderDetailViewModel.viewLocated()
    }
    
    func checkDeliveryType() {
        guard let order = orderDetailViewModel.order else {return}
        if orderDetailViewModel.checkDeliveryType() {
            deliveryLabel.text = "(Kurye Ücreti: 20 TL)"
            deliveryLabel.isHidden = false
            deliveryTypeLabel.text = "Kurye"
            totalLabel.text = "\(formatDouble((Double(order.userOrder.quantity) * orderDetailViewModel.totalAmount))) TL"
        } else {
            deliveryLabel.isHidden = true
            deliveryTypeLabel.text = "Gel-Al"
        }
    }
}

extension OrderDetailViewController: OrderDetailViewModelOutputProtocol {
    func couponUpdated() {
        guard let couponId = orderDetailViewModel.coupon else {
            couponLabel.isHidden = true
            couponStateLabel.isHidden = true
            return
        }
        couponLabel.isHidden = false
        couponStateLabel.isHidden = false
        couponStateLabel.text = "Kupon(\(couponId.code))"
        couponLabel.text = "-\(couponId.discountValue) TL"
        totalLabel.text = "\(formatDouble(orderDetailViewModel.totalAmount)) TL"
        
    }
    
    func errorCoupon() {
        couponLabel.isHidden = true
        couponStateLabel.isHidden = true
    }
    
    func update() {
        print("update")
    }
    
    func error() {
        print("error")
    }
}
