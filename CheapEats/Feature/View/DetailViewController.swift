//
//  DetailViewController.swift
//  CheapEats
//
//  Created by Emre on 29.11.2024.
//

import UIKit

final class DetailViewController: UIViewController {
    //MARK: -Variables
    var detailViewModel: DetailViewModelProtocol = DetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Detail")
    }
}

extension DetailViewController: DetailViewModelOutputProtocol {
    func update() {
        print("update")
    }
    
    func error() {
        print("error")
    }
}
