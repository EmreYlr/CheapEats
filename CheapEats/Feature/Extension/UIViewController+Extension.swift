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
    
    func addHorizontalLine(
        toView containerView: UIView,
        belowView: UIView,
        padding: CGFloat = 10,
        color: UIColor = .lightGray,
        thickness: CGFloat = 1,
        horizontalPadding: CGFloat = 0
    ) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(lineView)

        NSLayoutConstraint.activate([
            lineView.topAnchor.constraint(equalTo: belowView.bottomAnchor, constant: padding),
            lineView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: horizontalPadding),
            lineView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -horizontalPadding),
            lineView.heightAnchor.constraint(equalToConstant: thickness)
        ])
    }

}
