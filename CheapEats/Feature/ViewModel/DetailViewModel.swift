//
//  DetailViewModel.swift
//  CheapEats
//
//  Created by Emre on 29.11.2024.
//

import Foundation

protocol DetailViewModelProtocol {
    var delegate: DetailViewModelOutputProtocol? { get set }
    var product: Product? { get set }
}
protocol DetailViewModelOutputProtocol: AnyObject {
    func update()
    func error()
}

final class DetailViewModel {
    weak var delegate: DetailViewModelOutputProtocol?
    var product: Product?
}

extension DetailViewModel: DetailViewModelProtocol { }
