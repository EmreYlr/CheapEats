//
//  BorderAndShadow.swift
//  CheapEats
//
//  Created by Emre on 22.02.2025.
//

import UIKit

protocol BorderAndShadow {
    func setBorder(with CALayer: CALayer)
    func setShadow(with CALayer: CALayer, shadowOffset: Bool)
}
extension BorderAndShadow {
    func setBorder(with CALayer: CALayer) {
        CALayer.borderColor = UIColor.gray.cgColor
        CALayer.borderWidth = 0.2
    }
    
    func setShadow(with CALayer: CALayer, shadowOffset: Bool) {
        CALayer.shadowColor = UIColor.black.cgColor
        CALayer.masksToBounds = false
        CALayer.shadowOpacity = 0.5
        if shadowOffset {
            CALayer.shadowOffset = CGSize(width: 2, height: 0)
        }else{
            CALayer.shadowOffset = CGSize(width: 0, height: 2)
        }
        
        CALayer.shadowRadius = 3.0
    }
}

extension UITableViewCell: BorderAndShadow {}
extension UIViewController: BorderAndShadow {}
extension UICollectionViewCell: BorderAndShadow {}
