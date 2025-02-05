//
//  MapScreenViewController.swift
//  CheapEats
//
//  Created by Emre on 1.02.2025.
//

import UIKit
import MapKit

final class MapScreenViewController: UIViewController {
    //MARK: -Variables
    
    @IBOutlet weak var accessView: UIView!
    
    @IBOutlet weak var accessButon: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    var mapScreenViewModel: MapScreenViewModelProtocol = MapScreenViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapScreenViewController")
        mapScreenViewModel.delegate = self
        initLoad()
        setupMap()
        
    }
    
    private func initLoad() {
        mapView.layer.cornerRadius = 10
        if mapScreenViewModel.checkLocationCoordinate() {
            accessView.isHidden = true
            mapView.isHidden = false
        } else{
            accessView.isHidden = false
            mapView.isHidden = true
        }
    }
    
    private func setupMap() {
        mapScreenViewModel.centerMapToLocation(with: mapView)
    }
    
    @IBAction func accessButonClicked(_ sender: UIButton) {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}
extension MapScreenViewController: MapScreenViewModelOutputProtocol {
    func update() {
        print("update")
    }
    
    func error() {
        print("error")
    }
    
    
}
