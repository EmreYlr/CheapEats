//
//  FilterViewController.swift
//  CheapEats
//
//  Created by Emre on 1.12.2024.
//

import UIKit

final class FilterViewController: UIViewController {
    //MARK: -Variables
    @IBOutlet weak var mealTypeButton: UIButton!
    @IBOutlet weak var filterSelectedLabel: UILabel!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var minMealPriceSegment: UISegmentedControl!
    @IBOutlet weak var distanceSegment: UISegmentedControl!
    weak var delegate: FilterViewModelOutputProtocol?
    var filterViewModel: FilterViewModelProtocol = FilterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSettings()
        minMealPriceSegment.layer.shadowOpacity = 0
        distanceSegment.layer.shadowOpacity = 0
        configureView(buttonView, cornerRadius: 10)
        configureView(applyButton, cornerRadius: 10)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if filterViewModel.selectedMealTypes.isEmpty {
            filterSelectedLabel.text = "Tümü"
        } else {
            filterSelectedLabel.text = filterViewModel.selectedMealTypes.joined(separator: ", ")
        }
        minMealPriceSegment.selectedSegmentIndex = filterViewModel.selectedMinMealPrice
        distanceSegment.selectedSegmentIndex = filterViewModel.selectedDistance
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func mealTypeButtonClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let bottomSheetVC = storyboard.instantiateViewController(withIdentifier: "BottomSheetViewController") as? BottomSheetViewController {
            bottomSheetVC.modalPresentationStyle = .pageSheet
            if let sheet = bottomSheetVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
            }
            filterViewModel.emptyCheckSelectedItem(bottomSheetVC: bottomSheetVC)
            bottomSheetVC.delegate = self
            present(bottomSheetVC, animated: true)
        }
        
    }
    func navigationBarSettings() {
        let clearButton = UIBarButtonItem(title: "Temizle", style: .plain, target: self, action: #selector(clearButtonTapped))
        clearButton.tintColor = UIColor(named: "ButtonColor")
        navigationItem.rightBarButtonItem = clearButton
    }
    
    @IBAction func minMealPriceSegmentChanged(_ sender: UISegmentedControl) {
        print(sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "Tümü")
        filterViewModel.selectedMinMealPrice = sender.selectedSegmentIndex
    }

    @IBAction func distanceSegmentChanged(_ sender: UISegmentedControl) {
        print(sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "Tümü")
        filterViewModel.selectedDistance = sender.selectedSegmentIndex
        
    }
    
    @IBAction func applyButtonClicked(_ sender: Any) {
        delegate?.didApplyFilter(selectedMealTypes: filterViewModel.selectedMealTypes, minMealPrice: filterViewModel.selectedMinMealPrice, distance: filterViewModel.selectedDistance)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func clearButtonTapped() {
        filterViewModel.clearFilters()
        filterSelectedLabel.text = "Tümü"
        minMealPriceSegment.selectedSegmentIndex = 0
        distanceSegment.selectedSegmentIndex = 0
    }
}

extension FilterViewController: BottomSheetViewModelDelegate {
    func didApplySelection(selectedOptions: [String]) {
        filterViewModel.selectedMealTypes = selectedOptions
        print("Seçilen Yemek Türleri: \(filterViewModel.selectedMealTypes)")
        if selectedOptions.isEmpty {
            filterSelectedLabel.text = "Tümü"
        }else{
            filterSelectedLabel.text = filterViewModel.selectedMealTypes.joined(separator: ", ")
        }
    }
}
