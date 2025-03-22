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
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var stateView: UIView!
    @IBOutlet weak var discoveryButton: UIButton!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var oldTotalLabel: UILabel!
    @IBOutlet weak var trashButton: UIBarButtonItem!
    
    private var dashedLines: [CAShapeLayer] = []
    static var isComingFromThirdVC: Bool = false
    var cartViewModel: CartViewModelProtocol = CartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initScreen()
        initTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        
        if CartViewController.isComingFromThirdVC {
            CartViewController.isComingFromThirdVC = false
            addStaticDashedLines()
        } else {
            cartViewModel.getCartItems()
            addDashedLines()
        }
        
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
        
        deliveryView.layer.cornerRadius = deliveryView.frame.size.width / 2
        paymentView.layer.cornerRadius = paymentView.frame.size.width / 2
        checkOrderView.layer.cornerRadius = checkOrderView.frame.size.width / 2
        checkOrderImageView.layer.masksToBounds = true
        deliveryImageView.layer.masksToBounds = true
        paymentImageView.layer.masksToBounds = true
        checkOrderImageView.layer.cornerRadius = 5
        deliveryImageView.layer.cornerRadius = 5
        paymentImageView.layer.cornerRadius = 5
        totalView.layer.cornerRadius = 5
        setShadow(with: totalView.layer, shadowOffset: true)
        nextButton.layer.cornerRadius = 5
    }
    
    private func updateTotalLabel() {
        totalLabel.text = "\(formatDouble(cartViewModel.totalAmount)) TL"
        oldTotalLabel.text = "\(formatDouble(cartViewModel.oldTotalAmount)) TL"
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
    
    private func addStaticDashedLines() {
        guard let checkImage = checkOrderView, let deliveryImage = deliveryView, let paymentImage = paymentView else { return }
        let imageViews = [checkImage, deliveryImage, paymentImage]
        
        dashedLines = DashedLineManager.shared.createNonAnimatedDashedLinesBetweenImages(
            imageViews: imageViews,
            in: sectionView,
            selectedIndices: [0],
            lineWidth: 2.0,
            dashPattern: [6, 3],
            defaultColor: .lightGray,
            selectedColor: .button,
            padding: 8
        )
    }
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        let SB = UIStoryboard(name: "Main", bundle: nil)
        let deliveryVC = SB.instantiateViewController(withIdentifier: "DeliveryViewController") as! DeliveryViewController
        deliveryVC.deliveryViewModel.cartItems = cartViewModel.cartItems
        deliveryVC.deliveryViewModel.totalAmount = cartViewModel.totalAmount
        deliveryVC.deliveryViewModel.oldTotalAmount = cartViewModel.oldTotalAmount
        navigationController?.pushViewController(deliveryVC, animated: true)
    }
    
    @IBAction func discoveryButtonClicked(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func trashButtonClicked(_ sender: UIBarButtonItem) {
        showTwoButtonAlert(title: "Sepeti Temizle", message: "Sepeti temizlemek istediğinizden emin misiniz?", firstButtonTitle: "İptal", firstButtonHandler: .none, secondButtonTitle: "Temizle", secondButtonHandler: { _ in
            self.cartViewModel.clearCart()
        })
    }
}

extension CartViewController: CartViewModelOutputProtocol {
    func update() {
        print("update")
        stateView.isHidden = true
        tableView.reloadData()
    }
    
    func emptyCart() {
        print("emptyCart")
        stateView.isHidden = false
    }
    
    func reloadTotalAmount() {
        updateTotalLabel()
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
