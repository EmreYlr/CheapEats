//
//  DashedLine.swift
//  CheapEats
//
//  Created by Emre on 14.03.2025.
//

import UIKit

final class DashedLineManager {
    static let shared = DashedLineManager()
    
    private init() {}
    
    func createDashedLine(
        from firstImageView: UIView,
        to secondImageView: UIView,
        in containerView: UIView,
        animate: Bool = false,
        lineWidth: CGFloat = 2.0,
        dashPattern: [NSNumber] = [6, 3],
        fromColor: UIColor = .lightGray,
        toColor: UIColor = .green,
        animationDuration: TimeInterval = 1.5,
        padding: CGFloat = 8
    ) -> CAShapeLayer {
        
        let startX = firstImageView.frame.maxX
        let endX = secondImageView.frame.minX
        let midY = firstImageView.frame.midY

        let path = UIBezierPath()
        path.move(to: CGPoint(x: startX + padding, y: midY))
        path.addLine(to: CGPoint(x: endX - padding, y: midY))

        let dashedLayer = CAShapeLayer()
        dashedLayer.path = path.cgPath
        dashedLayer.strokeColor = fromColor.cgColor
        dashedLayer.lineWidth = lineWidth
        dashedLayer.lineDashPattern = dashPattern
        dashedLayer.fillColor = nil
        
        containerView.layer.addSublayer(dashedLayer)

        if animate {
            animateStrokeColorChange(
                dashedLayer,
                fromColor: fromColor,
                toColor: toColor,
                duration: animationDuration
            )
        }
        
        return dashedLayer
    }
   
    func createDashedLinesBetweenImages(
        imageViews: [UIView],
        in containerView: UIView,
        animateIndices: [Int] = [0],
        lineWidth: CGFloat = 2.0,
        dashPattern: [NSNumber] = [6, 3],
        fromColor: UIColor = .lightGray,
        toColor: UIColor = .green,
        animationDuration: TimeInterval = 1.5,
        padding: CGFloat = 8
    ) -> [CAShapeLayer] {
        
        guard imageViews.count >= 2 else { return [] }
        
        var dashedLines: [CAShapeLayer] = []
        for index in 0..<(imageViews.count - 1) {
            let firstImageView = imageViews[index]
            let secondImageView = imageViews[index + 1]
            let shouldAnimate = animateIndices.contains(index)
            
            let dashedLine = createDashedLine(
                from: firstImageView,
                to: secondImageView,
                in: containerView,
                animate: shouldAnimate,
                lineWidth: lineWidth,
                dashPattern: dashPattern,
                fromColor: fromColor,
                toColor: toColor,
                animationDuration: animationDuration,
                padding: padding
            )
            
            dashedLines.append(dashedLine)
        }
        
        return dashedLines
    }

    func createNonAnimatedDashedLinesBetweenImages(
        imageViews: [UIView],
        in containerView: UIView,
        selectedIndices: [Int] = [0],
        lineWidth: CGFloat = 2.0,
        dashPattern: [NSNumber] = [6, 3],
        defaultColor: UIColor = .lightGray,
        selectedColor: UIColor = .green,
        padding: CGFloat = 8
    ) -> [CAShapeLayer] {
        
        guard imageViews.count >= 2 else { return [] }
        
        var dashedLines: [CAShapeLayer] = []
        for index in 0..<(imageViews.count - 1) {
            let firstImageView = imageViews[index]
            let secondImageView = imageViews[index + 1]
            let isSelected = selectedIndices.contains(index)
            let lineColor = isSelected ? selectedColor : defaultColor
            
            let startX = firstImageView.frame.maxX
            let endX = secondImageView.frame.minX
            let midY = firstImageView.frame.midY

            let path = UIBezierPath()
            path.move(to: CGPoint(x: startX + padding, y: midY))
            path.addLine(to: CGPoint(x: endX - padding, y: midY))

            let dashedLayer = CAShapeLayer()
            dashedLayer.path = path.cgPath
            dashedLayer.strokeColor = lineColor.cgColor
            dashedLayer.lineWidth = lineWidth
            dashedLayer.lineDashPattern = dashPattern
            dashedLayer.fillColor = nil
            
            containerView.layer.addSublayer(dashedLayer)
            
            dashedLines.append(dashedLayer)
        }
        
        return dashedLines
    }
    
    private func animateStrokeColorChange(
        _ layer: CAShapeLayer,
        fromColor: UIColor,
        toColor: UIColor,
        duration: TimeInterval
    ) {
        let colorAnimation = CABasicAnimation(keyPath: "strokeColor")
        colorAnimation.fromValue = fromColor.cgColor
        colorAnimation.toValue = toColor.cgColor
        colorAnimation.duration = duration
        colorAnimation.fillMode = .forwards
        colorAnimation.isRemovedOnCompletion = false

        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0.0
        strokeEndAnimation.toValue = 1.0
        strokeEndAnimation.duration = duration
        strokeEndAnimation.fillMode = .forwards
        strokeEndAnimation.isRemovedOnCompletion = false
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [colorAnimation, strokeEndAnimation]
        animationGroup.duration = duration
        animationGroup.fillMode = .forwards
        animationGroup.isRemovedOnCompletion = false

        layer.strokeColor = toColor.cgColor
        layer.strokeEnd = 0.0
        
        layer.add(animationGroup, forKey: "dashedLineAnimation")
    }
    
    func removeLayers(_ layers: [CAShapeLayer?]) {
        for layer in layers {
            layer?.removeFromSuperlayer()
        }
    }
}
