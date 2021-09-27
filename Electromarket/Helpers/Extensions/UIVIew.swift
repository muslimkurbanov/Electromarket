//
//  UIVIew.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 03.08.2021.
//

import UIKit

// MARK: - IBInspectable
extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor ?? CGColor(gray: 0, alpha: 0))
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    func hideWithAnimate() {
        
        UIView.animate(withDuration: 0.5) {
            
            self.alpha = 0
            self.isHidden = true
        }
    }
    
    func showWithAnimate() {
        
        UIView.animate(withDuration: 0.5) {
            
            self.alpha = 1
            self.isHidden = false
        }
    }
}

//MARK: - GradientBackground
extension UIView {
    
    func gradientBackground(firstColor: UIColor, secondColor: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.frame.height)
        gradientLayer.colors =  [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.cornerRadius = 2
        self.cornerRadius = 2
                
//        self.layer.insertSublayer(gradientLayer, at: 0)
//        self.layer.insertSublayer(gradientLayer, above: layer)
        self.layer.addSublayer(gradientLayer)
    }
}

// MARK: - Dashed line
extension UIView {
    
    func makeDashedLine(start p0: CGPoint, end p1: CGPoint, dashWidth: NSNumber, gapWidth: NSNumber, lineWidth: CGFloat = 1, color: UIColor?, view: UIView) {
        
        let cgColor = color?.cgColor ?? UIColor.black.cgColor
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineDashPattern = [dashWidth, gapWidth]

        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let layer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        layer.path = path.cgPath
        self.layer.mask = layer
    }
}


class BottomDashedView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        makeDashedLine(
            start: CGPoint(x: self.bounds.minX, y: self.bounds.maxY),
            end: CGPoint(x: self.bounds.maxX, y: self.bounds.maxY),
            dashWidth: 4,
            gapWidth: 2,
            color: UIColor.gray,
            view: self)
    }
}
