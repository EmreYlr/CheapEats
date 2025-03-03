import UIKit
import MapKit

final class MapScreenViewController: UIViewController {
    //MARK: -Variables
    @IBOutlet weak var accessView: UIView!
    @IBOutlet weak var accessButon: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    var mapScreenViewModel: MapScreenViewModelProtocol = MapScreenViewModel()
    private let categoriesToShow = [
        MKPointOfInterestCategory.park,
        MKPointOfInterestCategory.museum,
        MKPointOfInterestCategory.nationalPark,
        MKPointOfInterestCategory.stadium,
        MKPointOfInterestCategory.university,
        MKPointOfInterestCategory.hospital,
        MKPointOfInterestCategory.hotel,
        MKPointOfInterestCategory.pharmacy,
        MKPointOfInterestCategory.school,
        MKPointOfInterestCategory.gasStation
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapScreenViewController")
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
        mapScreenViewModel.delegate = self
        mapView.delegate = self
        mapView.showsCompass = false
        mapView.showsScale = false
        mapView.showsTraffic = false
        mapView.showsBuildings = false
        mapView.showsLargeContentViewer = false
        mapView.showsUserTrackingButton = true
        mapView.pointOfInterestFilter = MKPointOfInterestFilter(including: categoriesToShow)
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
        mapScreenViewModel.addRestaurantPins(with: mapView)
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
