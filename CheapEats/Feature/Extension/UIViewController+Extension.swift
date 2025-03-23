//
//  ViewController+Extension.swift
//  CheapEats
//
//  Created by Emre on 9.12.2024.
//

import Foundation
import UIKit

extension UIViewController {
    func configureView(_ view: UIView, cornerRadius: CGFloat) {
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
    }
    
    func configureView(_ view: UIView, cornerRadius: CGFloat, borderColor: UIColor?, borderWidth: CGFloat) {
        view.layer.cornerRadius = cornerRadius
        view.layer.borderColor = borderColor?.cgColor
        view.layer.borderWidth = borderWidth
        view.layer.masksToBounds = true
    }
    
    func addHorizontalLine(toView containerView: UIView, belowView: UIView, padding: CGFloat = 10, color: UIColor = .lightGray, thickness: CGFloat = 1) {
        let lineLayer = CALayer()
        lineLayer.backgroundColor = color.cgColor
        lineLayer.frame = CGRect(
            x: 0,
            y: belowView.frame.maxY + padding,
            width: containerView.frame.width,
            height: thickness
        )
        
        containerView.layer.addSublayer(lineLayer)
    }
}
