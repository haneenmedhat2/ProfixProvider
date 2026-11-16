//
//  AppHelper.swift
// NewBase
//
//  Created by MGAbouarab on 30/12/2023.
//

import UIKit
import CoreLocation
import MapKit
import CoreLocation

struct AppHelper {
    
    private init() {}
    
    static func changeWindowRoot(vc: UIViewController, options: UIView.AnimationOptions = .transitionCrossDissolve) {
        UIApplication.shared.windows.first?.rootViewController = vc
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        guard let window = window else {return}
        UIView.transition(with: window, duration: 0.3, options: options, animations: nil, completion: nil)
    }
    

    static func openUrl(_ url: String?) {
        guard let stringUrl = url else {return}
        if let url = URL(string: stringUrl) {
            UIApplication.shared.open(url)
        }
    }
    
    
    static func blockUser() {
        Session.isLogin = false
        Session.token  = nil
        Session.user = nil
        UserDefaults.notificationCount = 0

        let vc = LoginVC(viewModel: LoginVM())
        let nav = BaseNav(rootViewController: vc)
        AppHelper.changeWindowRoot(vc: nav, options: .transitionCurlDown)
    }
    
    static func getAddressFromCoordinates(latitude: Double, longitude: Double, completion: @escaping (String) -> Void) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                completion("Unknown Location")
                return
            }
            
            if let placemark = placemarks?.first {
                let city = placemark.locality ?? ""
                let area = placemark.subLocality ?? ""
                let country = placemark.country ?? ""
                let address = "\(area), \(city), \(country)"
                completion(address)
            } else {
                completion("Unknown Location")
            }
        }
    }
    
    static func addDashedBorder(to imageView: UIImageView) {
        imageView.layer.sublayers?.removeAll(where: { $0.name == "DashedBorder" })
        
        let dashedBorder = CAShapeLayer()
        dashedBorder.name = "DashedBorder"
        dashedBorder.strokeColor = UIColor.main.cgColor
        dashedBorder.lineDashPattern = [4, 4]
        dashedBorder.fillColor = nil
        dashedBorder.lineWidth = 3
        
        let cornerRadius = imageView.layer.cornerRadius
        dashedBorder.path = UIBezierPath(roundedRect: imageView.bounds, cornerRadius: cornerRadius).cgPath
        dashedBorder.frame = imageView.bounds
        
        imageView.layer.addSublayer(dashedBorder)
    }
    
    static func setupAddressBarButton(
        address: String,
        target: Any?,
        action: Selector
    ) -> UIBarButtonItem {

        // location icon
        let locationImageView = UIImageView(image: UIImage(resource: .location06))
        locationImageView.contentMode = .scaleAspectFit
        locationImageView.tintColor = .black
        locationImageView.translatesAutoresizingMaskIntoConstraints = false
        locationImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        locationImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true

        // address label
        let label = UILabel()
        label.font = UIFont.myMediumFont(ofSize: 14)
        label.textColor = .white
        label.text = address
        label.numberOfLines = 1

        // arrow down icon
        let arrowImageView = UIImageView(image: UIImage(resource: .arrowDown02))
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.tintColor = .white
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.widthAnchor.constraint(equalToConstant: 14).isActive = true
        arrowImageView.heightAnchor.constraint(equalToConstant: 14).isActive = true

        // stack view
        let stackView = UIStackView(arrangedSubviews: [
            locationImageView,
            label,
            arrowImageView
        ])
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .center
        stackView.isUserInteractionEnabled = true

        // tap gesture
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        stackView.addGestureRecognizer(tapGesture)

        return UIBarButtonItem(customView: stackView)
    }

}

