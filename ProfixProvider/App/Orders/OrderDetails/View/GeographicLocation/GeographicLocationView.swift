//
//  GeographicLocationView.swift
//  Profix
//
//  Created by Haneen on 15/01/2026.
//

import UIKit
import GoogleMaps

class GeographicLocationView: UIView {

    //MARK: - Outlets -

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var geograpgicView: UIView!
    
    //MARK: - Properites -
     
    var lat : Double = 0.0
    var long : Double = 0.0
    
    //MARK: - Initializer -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewSetup()
    }
    
    //MARK: - Nib file configuration -
    
    func viewSetup(){
        let view = loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)
        mapView.layer.cornerRadius = 12
    }
        
    func loadViewFromNib()-> UIView {
        let nib = UINib(nibName: "GeographicLocationView", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func setupData(location : String ,lat : Double , long : Double, type: ViewType){
        geograpgicView.backgroundColor = type.backgroundColor
        locationLabel.text = location
        self.lat = lat
        self.long = long
        setMapLocation()
    }
}

//MARK: - Map Hanlding -

extension GeographicLocationView {
    
    private func setMapLocation() {
        let camera = GMSCameraPosition.camera(withLatitude: lat,
                                              longitude: long,
                                              zoom: 16)
        mapView.animate(to: camera)
        mapView.clear()
        addMarker()
    }
    
    private func addMarker() {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.map = mapView
    }
}
