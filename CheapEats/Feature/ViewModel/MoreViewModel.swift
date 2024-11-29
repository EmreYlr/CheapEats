//
//  MoreViewModel.swift
//  CheapEats
//
//  Created by Emre on 29.11.2024.
//

import Foundation

protocol MoreViewModelProtocol {
    var delegate: MoreViewModelOutputProtocol? { get set }
}

protocol MoreViewModelOutputProtocol: AnyObject {
    
}

final class MoreViewModel {
    weak var delegate: MoreViewModelOutputProtocol?
}

extension MoreViewModel: MoreViewModelProtocol { }
