//
//  FormatDouble.swift
//  CheapEats
//
//  Created by Emre on 18.02.2025.
//
import UIKit

protocol FormatDouble {
    func formatDouble(_ value: Double) -> String
}

extension FormatDouble {
    func formatDouble(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", value)
        } else {
            return String(value)
        }
    }
}

extension UICollectionViewCell: FormatDouble {}
extension UITableViewCell: FormatDouble {}
extension UIViewController: FormatDouble {}
extension DeliveryViewModel: FormatDouble {}
