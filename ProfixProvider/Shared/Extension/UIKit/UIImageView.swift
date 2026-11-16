//
//  UIImageView.swift
// NewBase
//
//  Created by MGAbouarab on 29/12/2023.
//

import UIKit.UIImageView
import Kingfisher

extension UIImageView {
    func setWith(_ stringURL: String?) {
        self.kf.indicatorType = .activity
        let placeholder = UIImage(named: "AppIcon")
        guard let stringURL, let url = URL(string: stringURL) else {
            self.image = UIImage(named: "AppIcon")
            return
        }
        self.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [
                .onFailureImage(placeholder),
                .transition(.fade(0.4))
            ]
        )
    }
}
extension UIImage {
    func saveToTempDirectory() -> URL? {
        guard let data = self.jpegData(compressionQuality: 1.0) else { return nil }
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = tempDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            return fileURL
        } catch {
            print("Error saving image to temp directory: \(error)")
            return nil
        }
    }
}
extension UIView {
    
    
    
    func flipX() {
        transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
    
    func flipY() {
        transform = CGAffineTransform(scaleX: transform.a, y: -transform.d)
    }
    
    func appStypeTextField() {
        layer.cornerRadius = 5
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 1
    }
    
    func makeSmallRadius() {
        self.layer.cornerRadius = ViewConstants.shared.smallCornerRadius
    }
    
    func makeLargeRadius() {
        self.layer.cornerRadius = ViewConstants.shared.largeCornerRadius
    }
    
    func makeShadow() {
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 2.0, height: 0)
        self.layer.shadowRadius = ViewConstants.shared.smallCornerRadius
        self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    func makeCircle() {
        let width = self.frame.size.width
        self.layer.cornerRadius = width / 2
        self.clipsToBounds = true
    }
    
    func createDashedLine(from point1: CGPoint, to point2: CGPoint, color: UIColor, strokeLength: NSNumber, gapLength: NSNumber, width: CGFloat) {
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineDashPattern = [strokeLength, gapLength]
        
        let path = CGMutablePath()
        path.addLines(between: [point1, point2])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    
    func createDashedLine(color: UIColor) {
        let point1 = CGPoint(x: bounds.minX, y: bounds.minY)
        let point2 = CGPoint(x: bounds.maxX, y: bounds.minY)
        let width: CGFloat = 2
        
        let strokeLength: NSNumber = 5
        let gapLength: NSNumber = 3
        
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineDashPattern = [strokeLength, gapLength]
        
        let path = CGMutablePath()
        path.addLines(between: [point1, point2])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    
    func removeDashLine() {
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
    
    func setupChatBootStyleEnglish() {
        clipsToBounds = true
        layer.cornerRadius = 10
        layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner,
            .layerMaxXMaxYCorner,
        ]
    }
    
    func setupChatBootStyleArabic() {
        clipsToBounds = true
        layer.cornerRadius = 10
        layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner,
            .layerMinXMaxYCorner,
        ]
    }
    
    func addDashedBorder() {
        let color = UIColor.main
        
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let frameSize = frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width / 2, y: frameSize.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6, 3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 4).cgPath
        
        layer.addSublayer(shapeLayer)
    }
    
//    func addTapGesture(numberOfTapsRequired: Int = 1, _ action: @escaping () -> Void) {
//        endEditing(true)
//        isUserInteractionEnabled = true
//        
//        let tap = MyTapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//        let p = tap.location(in: self)
//        print("🙄p \(p)")
//        tap.action = action
//        tap.numberOfTapsRequired = numberOfTapsRequired
//        addGestureRecognizer(tap)
//        
//        endEditing(true)
//    }
//    
//    class MyTapGestureRecognizer: UITapGestureRecognizer {
//        var action: (() -> Void)?
//    }
//    
//    @objc func handleTap(_ sender: MyTapGestureRecognizer) {
//        alpha = 0.2
//        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveLinear], animations: { self.alpha = 1.0 }, completion: nil)
//        sender.action!()
//    }
//    
}
class TopCornerView: SwipedView {
    override  func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = ViewConstants.shared.largeCornerRadius
        self.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
        self.clipsToBounds = true
    }
}

class SwipedView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.addGestureRecognizer(panGesture)
        self.isUserInteractionEnabled = true
    }
    
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let view = parentContainerViewController?.view else { return }
        let translation = gestureRecognizer.translation(in: view)
        
        switch gestureRecognizer.state {
        case .began, .changed:
            
            //MARK: - Make it swipe in just down -
            if translation.y > 0{
                self.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
        case .ended:
            //MARK: - Check ended -
            let shouldDismiss = translation.y > (view.bounds.height / 2 - 350) // Swipe down by at least half the view's height
            
            // Animate the view off the screen or back to its original position
            UIView.animate(withDuration: 0.3) {
                if shouldDismiss {
                    self.transform = CGAffineTransform(translationX: 0, y: view.bounds.height)
                } else {
                    self.transform = .identity
                }
            }
            if shouldDismiss {
                parentContainerViewController?.dismiss(animated: false)
            }
        default:
            break
        }
    }
}
