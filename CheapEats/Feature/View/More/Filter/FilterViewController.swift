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
    
    var filterViewModel: FilterViewModelProtocol = FilterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterViewModel.delegate = self
        buttonView.roundCorners(corners: [.allCorners], radius: 10)
        applyButton.roundCorners(corners: [.allCorners], radius: 10)
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    @IBAction func minMealPriceSegmentChanged(_ sender: UISegmentedControl) {
        print(sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "Tümü")
    }

    @IBAction func distanceSegmentChanged(_ sender: UISegmentedControl) {
        print(sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "Tümü")
    }
    
    @IBAction func applyButtonClicked(_ sender: Any) {
        filterViewModel.applyFilter()
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

extension FilterViewController: FilterViewModelOutputProtocol {
    func didApplyFilter() {
        navigationController?.popViewController(animated: true)
    }
}
