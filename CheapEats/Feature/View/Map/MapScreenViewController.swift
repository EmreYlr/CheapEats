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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUserLocationOnMap()
    }
    
    private func initLoad() {
        if mapScreenViewModel.checkLocationCoordinate() {
            accessView.isHidden = true
            mapView.isHidden = false
        } else {
            accessView.isHidden = false
            mapView.isHidden = true
        }
    }
    
    private func setupMap() {
        mapView.delegate = self
        mapView.showsCompass = false
        mapView.showsScale = false
        mapView.showsTraffic = false
        mapView.showsBuildings = false
        mapView.showsLargeContentViewer = false
        mapView.showsUserTrackingButton = true
        mapScreenViewModel.centerMapToLocation(with: mapView)
        updateUserLocationOnMap()
        addRestaurantPins()
    }
    
    private func updateUserLocationOnMap() {
        if let oldAnnotation = mapScreenViewModel.userAnnotation {
            mapView.removeAnnotation(oldAnnotation)
        }
        if let userAnnotation = mapScreenViewModel.createUserLocationAnnotation() {
            mapView.addAnnotation(userAnnotation)
        }
    }
    
    @IBAction func accessButonClicked(_ sender: UIButton) {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func addRestaurantPins() {
        for restaurant in mapScreenViewModel.mockRestaurants {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: restaurant.location.latitude, longitude: restaurant.location.longitude)
            annotation.title = restaurant.companyName
            mapView.addAnnotation(annotation)
        }
    }
}

extension MapScreenViewController: MapScreenViewModelOutputProtocol {
    func update() {
        print("update")
        updateUserLocationOnMap()
    }
    
    func error() {
        print("error")
    }
}
