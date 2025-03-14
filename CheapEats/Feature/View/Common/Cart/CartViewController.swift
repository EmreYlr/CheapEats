//
//  CartViewController.swift
//  CheapEats
//
//  Created by Emre on 11.03.2025.
//
import UIKit

final class CartViewController: UIViewController {
    //MARK: -Variables
    @IBOutlet weak var sectionView: UIView!
    @IBOutlet weak var checkOrderImageView: UIImageView!
    @IBOutlet weak var deliveryImageView: UIImageView!
    @IBOutlet weak var paymentImageView: UIImageView!
    
    private var dashedLines: [CAShapeLayer] = []
    
    var cartViewModel: CartViewModelProtocol = CartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        print(CartManager.shared.getProduct() ?? "")
        // Sepet verilerini yenileme
        addDashedLines()
    }

    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = UIColor(named: "ButtonColor")
        DashedLineManager.shared.removeLayers(dashedLines.map { $0 })
        dashedLines.removeAll()
    }
    
    func initScreen() {
        cartViewModel.delegate = self
        checkOrderImageView.layer.cornerRadius = 10
        deliveryImageView.layer.cornerRadius = 10
        paymentImageView.layer.cornerRadius = 10
    }
    
    private func addDashedLines() {
        guard let checkImage = checkOrderImageView, let deliveryImage = deliveryImageView, let paymentImage = paymentImageView else { return }
        let imageViews = [checkImage, deliveryImage, paymentImage]
        
        dashedLines = DashedLineManager.shared.createDashedLinesBetweenImages(
            imageViews: imageViews,
            in: sectionView,
            animateIndices: [0],
            lineWidth: 2.0,
            dashPattern: [6, 3],
            fromColor: .lightGray,
            toColor: .button,
            animationDuration: 0.7,
            padding: 8
        )
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
