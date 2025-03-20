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
    @IBOutlet weak var checkOrderView: UIView!
    @IBOutlet weak var deliveryView: UIView!
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    private var dashedLines: [CAShapeLayer] = []
    var cartViewModel: CartViewModelProtocol = CartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initScreen()
        initTableView()
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
        //Çıkarabilirim
        configureView(sectionView, cornerRadius: 5)
        setShadow(with: sectionView.layer, shadowOffset: true)
        
        deliveryView.layer.cornerRadius = deliveryView.frame.size.width / 2
        paymentView.layer.cornerRadius = paymentView.frame.size.width / 2
        checkOrderView.layer.cornerRadius = checkOrderView.frame.size.width / 2
        checkOrderImageView.layer.masksToBounds = true
        deliveryImageView.layer.masksToBounds = true
        paymentImageView.layer.masksToBounds = true
        
        nextButton.layer.cornerRadius = 5
    }
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "cartCell")
        tableView.layer.cornerRadius = 10
        
    }
    
    private func addDashedLines() {
        guard let checkImage = checkOrderView, let deliveryImage = deliveryView, let paymentImage = paymentView else { return }
        let imageViews = [checkImage, deliveryImage, paymentImage]
        
        dashedLines = DashedLineManager.shared.createDashedLinesBetweenImages(
            imageViews: imageViews,
            in: sectionView,
            animateIndices: [0],
            lineWidth: 2.0,
            dashPattern: [6, 3],
            fromColor: .lightGray,
            toColor: .button,
            animationDuration: 1,
            padding: 8
        )
    }
    @IBAction func nextButtonClicked(_ sender: UIButton) {
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
