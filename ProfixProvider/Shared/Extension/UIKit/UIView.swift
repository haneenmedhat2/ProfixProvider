//
//  UIView.swift
// NewBase
//
//  Created by MGAbouarab on 27/12/2023.
//

import UIKit

//MARK: - Animation -
extension UIView {
    
    @objc func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.2
        pulse.fromValue = 1.0
        pulse.toValue = 0.98
        pulse.autoreverses = true
        pulse.repeatCount = 1
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        layer.add(pulse, forKey: nil)
    }
    @objc func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.3
        flash.fromValue = 1
        flash.toValue = 0.6
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 1
        layer.add(flash, forKey: nil)
    }
    
    @objc func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-10.0, 10.0, -10.0, 10.0, -5.0, 5.0, -2.5, 2.5, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
}

extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = .zero
        layer.shadowRadius = 8
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func addActiveBorder() {
        self.layer.borderColor = .mainCGColor
        self.layer.borderWidth = 1
    }
    func addInactiveBorder() {
        self.layer.borderColor = UIColor.secondarySystemFill.cgColor
        self.layer.borderWidth = 1
    }
    func removeBorder() {
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 1
    }
    
    func addDashedBorder(withColor color: UIColor = .main) {
        let color = color.cgColor
        let name = "dashedLayer"
        for layer in self.layer.sublayers ?? [] {
            if layer.name == name {
                layer.removeFromSuperlayer()
            }
        }
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        shapeLayer.name = name
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: self.layer.cornerRadius).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    
}

class CornerView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.makeSmallRadius()
    }
}
class CornerBorderView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.makeLargeRadius()
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.secondaryDarkFont.withAlphaComponent(0.5).cgColor
        
    }
}
class MainCornerBorderView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.makeSmallRadius()
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.main.withAlphaComponent(0.5).cgColor
        
    }
}

class SmallCornerBorderView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.makeSmallRadius()
        self.layer.borderWidth = 0.4
        self.layer.borderColor = UIColor.secondaryDarkFont.withAlphaComponent(0.6).cgColor
        
    }
}
class SmallBorderView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.secondaryDarkFont.withAlphaComponent(0.5).cgColor
        
    }
}

extension UIView {
//    func dropShadow(color: UIColor = .label.withAlphaComponent(0.1)) {
//        layer.shadowColor = color.cgColor
//        layer.shadowOpacity = 1
//        layer.shadowOffset = .init(width: 0, height: -3)
//        layer.shadowRadius = 4
//        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
//        layer.shouldRasterize = true
//        layer.rasterizationScale = UIScreen.main.scale
//    }
}

extension UIView {
    var parentContainerViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while let responder = parentResponder {
            if let viewController = responder as? UIViewController {
                return viewController
            }
            parentResponder = responder.next
        }
        return nil
    }
}

private struct AssociatedKeys {
    static var tapHandler = UnsafeRawPointer(bitPattern: 0)
    static var swipeHandler = UnsafeRawPointer(bitPattern: 0)
}

//MARK: - Tap -
//extension UIView {
//    func addTapGesture(handler: @escaping () -> Void) {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//        self.isUserInteractionEnabled = true
//        self.addGestureRecognizer(tapGesture)
//        
//        // Store the closure in an associated object
//        objc_setAssociatedObject(self, &AssociatedKeys.tapHandler, handler, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//    }
//    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
//        if let tapHandler = objc_getAssociatedObject(self, &AssociatedKeys.tapHandler) as? () -> Void {
//            tapHandler()
//        }
//    }
//}

//MARK: - Swipe -
extension UIView {
    func addSwipeGesture(handler: @escaping () -> Void) {
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        self.addGestureRecognizer(swipeGesture)
        objc_setAssociatedObject(self, &AssociatedKeys.swipeHandler, handler, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    @objc private func handleSwipeGesture(_ gesture: UIPanGestureRecognizer) {
        
        
        if let swipeHandler = objc_getAssociatedObject(self, &AssociatedKeys.swipeHandler) as? () -> Void {
            let translation = gesture.translation(in: self.superview)
            let velocity = gesture.velocity(in: self.superview)
            
            switch gesture.state {
            case .began, .changed:
                // Update the view's position based on the gesture translation
                if translation.y > 0 {
                    self.transform = CGAffineTransform(translationX: 0, y: translation.y)
                } else if translation.y < 0 && translation.y > -30 {
                    let x = -(translation.y / 100)
                    self.transform = CGAffineTransform(scaleX: 1, y: 1+x)
                }
                
                
            case .ended:
                // Calculate the dismissal threshold based on the view's height
                let dismissalThreshold = self.bounds.height * 0.3
                
                // Dismiss the view if swiped downward or with sufficient velocity
                if translation.y > dismissalThreshold || velocity.y > 1000 {
                    swipeHandler()
                } else {
                    // Return the view to its original position
                    UIView.animate(withDuration: 0.3) {
                        self.transform = .identity
                    }
                }
                
            default:
                break
            }
        }
        
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while let responder = parentResponder {
            parentResponder = responder.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
class CustomCornerforFormsView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 8
        self.layer.shadowRadius = 8
        dropShadow()
    }
    
    
}
class CustomCircleforFormsView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 40
        self.layer.shadowRadius = 8
        dropShadow()
    }
    
    
}

import UIKit

extension UIView {
    func applyGradientBackground(colors: [UIColor], startPoint: CGPoint = CGPoint(x: 0.5, y: 0), endPoint: CGPoint = CGPoint(x: 0.5, y: 1)) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        // Remove existing gradient layers to avoid duplicates
        self.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
extension UIView {
    @IBInspectable var viewCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            clipsToBounds = true
        }
    }
    
    @IBInspectable var topCurve: Double {
        get {
            return layer.cornerRadius
        }
        
        set {
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            layer.cornerRadius = newValue
            clipsToBounds = true
        }
    }
    
    
    @IBInspectable var bottomCurve: Double {
        get {
            return layer.cornerRadius
        }
        
        set {
            layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            layer.cornerRadius = newValue
            clipsToBounds = true
        }
    }
    
    
    @IBInspectable var rightCurve: Double {
        get {
            return layer.cornerRadius
        }
        
        set {
            if Language.isRTL() {
                layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
                layer.cornerRadius = newValue
                clipsToBounds = true
            }else {
                layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
                layer.cornerRadius = newValue
                clipsToBounds = true
            }
        }
    }
    
    @IBInspectable var leftCurve: Double {
        get {
            return layer.cornerRadius
        }
        
        set {
            if Language.isRTL() {
                layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
                layer.cornerRadius = newValue
                clipsToBounds = true
            } else {
                layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
                layer.cornerRadius = newValue
                clipsToBounds = true
            }
        }
    }
}

extension UIView {
    
    @IBInspectable var rtCornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var rtBorderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    @IBInspectable var rtBorderColor: UIColor? {
        get { return UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor) }
        set { layer.borderColor = newValue?.cgColor }
    }
}


extension UIView {

    func startShimmer() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.systemGray5.cgColor,
            UIColor.systemGray4.cgColor,
            UIColor.systemGray5.cgColor
        ]

        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.frame = bounds

        layer.mask = gradient

        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = -bounds.width
        animation.toValue = bounds.width
        animation.duration = 1.2
        animation.repeatCount = .infinity

        gradient.add(animation, forKey: "shimmer")
    }
}
