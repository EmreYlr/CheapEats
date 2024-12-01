//
//  LineView.swift
//  CheapEats
//
//  Created by Emre on 1.12.2024.
//

import UIKit

class LineView: UIView {
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setStrokeColor(UIColor.lightGray.cgColor)
        context.setLineWidth(1.0)

        context.move(to: CGPoint(x: 10, y: self.bounds.height / 2))
        context.addLine(to: CGPoint(x: self.bounds.width - 10, y: self.bounds.height / 2))
        context.strokePath()
    }
  

}
