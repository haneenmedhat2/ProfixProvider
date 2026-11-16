//
//  BookingLocationVC.swift
//  Profix
//
//  Created by Haneen on 11/01/2026.
//

import UIKit
import Combine
import GoogleMaps

class BookingLocationVC: BaseViewController {

    //MARK: - Outlets -
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var confirmButton: MainButton!
    
    //MARK: - Properties -
    
    var viewModel : BookingLocationVMProtocol
    
    //MARK: - Initializer -
    
    init(viewModel : BookingLocationVMProtocol){
        self.viewModel = viewModel
        super.init(nibName: "BookingLocationVC", bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle -
    
    override func viewDidLoad(){
        super.viewDidLoad()
        initialConfiguration()
    }
    
    //MARK: - Initial Setup -
    
    func initialConfiguration(){
        self.title = "geo_location".localized
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = false
        confirmButton.isHidden = viewModel.locationMode.isConfirmBtnHidden
        
        if let selectedAddress = viewModel.selectedAddress {
            setMapLocation(selectedAddress)
        } else {
            AppLocationManager.shared.requestLocation { [weak self] model in
                guard let self = self else { return }
                self.setMapLocation(model)
            }
        }
    }
    
    private func setMapLocation(_ model: AddressModel) {
        let camera = GMSCameraPosition.camera(withLatitude: model.lat,
                                              longitude: model.long,
                                              zoom: 16)

        mapView.animate(to: camera)
        mapView.clear()
        addMarker(model)
        viewModel.selectedAddress = model
    }
    
    private func addMarker(_ model: AddressModel) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: model.lat, longitude: model.long)
        marker.title = model.desc
        marker.map = mapView
    }
    
    //MARK: - Action -
    
    @IBAction func didTapConfirm(_ sender: UIButton) {
        guard let address = viewModel.selectedAddress else { return }
        viewModel.onLocationSelected?(address)
        pop()
    }
    
    @IBAction func didTapCurrentLocation(_ sender: UIButton) {
        AppLocationManager.shared.requestLocation { [weak self] model in
            guard let self = self else { return }
            self.setMapLocation(model)
        }
    }
}

extension BookingLocationVC: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if viewModel.locationMode == .editLocation {
            AppHelper.getAddressFromCoordinates(latitude: coordinate.latitude , longitude:  coordinate.longitude) { [weak self] model in
                guard let self = self else { return }
                self.mapView.clear()
                self.addMarker(AddressModel(lat: coordinate.latitude, long: coordinate.longitude, desc: model))
                self.viewModel.selectedAddress = AddressModel(lat: coordinate.latitude, long: coordinate.longitude, desc: model)
            }
        }
    }
}
