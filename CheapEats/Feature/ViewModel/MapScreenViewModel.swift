//
//  MapScreenViewModel.swift
//  CheapEats
//
//  Created by Emre on 1.02.2025.
//

import Foundation

protocol MapScreenViewModelProtocol {
    var delegate: MapScreenViewModelOutputProtocol? { get set}
}

protocol MapScreenViewModelOutputProtocol: AnyObject {
    func update()
    func error()
}

final class MapScreenViewModel {
    weak var delegate: MapScreenViewModelOutputProtocol?
}

extension MapScreenViewModel: MapScreenViewModelProtocol {}
