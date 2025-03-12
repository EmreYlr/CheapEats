import UIKit
import MapKit

final class MapScreenViewController: UIViewController {
    //MARK: -Variables
    @IBOutlet weak var accessView: UIView!
    @IBOutlet weak var accessButon: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var cartButton: UIBarButtonItem!
    
    var mapScreenViewModel: MapScreenViewModelProtocol = MapScreenViewModel()
    let SB = UIStoryboard(name: "Main", bundle: nil)
    var cartVC: CartViewController?
    //TODO: -Fitreleme ekle(yakınlık-fiyat vs.)
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapScreenViewController")
        initLoad()
        setupMap()
        initCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUserLocationOnMap()
    }
    
    private func initLoad() {
        mapScreenViewModel.calculateAllDistances()
        if mapScreenViewModel.checkLocationCoordinate() {
            accessView.isHidden = true
            mapView.isHidden = false
        } else {
            accessView.isHidden = false
            mapView.isHidden = true
        }
    }
    private func initCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.register(UINib(nibName: "MapCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        collectionViewSettings(with: collectionView)
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
        mapView.pointOfInterestFilter = MKPointOfInterestFilter(including: MKPointOfInterestCategory.defaultCategoriesToShow)
        mapScreenViewModel.centerMapToLocation(with: mapView)
        updateUserLocationOnMap()
        addRestaurantPins()
    }
    
    private func updateUserLocationOnMap() {
        if let userAnnotation = mapScreenViewModel.userAnnotation {
            if let newCoordinate = mapScreenViewModel.getUserCoordinate() {
                userAnnotation.coordinate = newCoordinate
            }
        } else {
            if let newAnnotation = mapScreenViewModel.createUserLocationAnnotation() {
                mapView.addAnnotation(newAnnotation)
            }
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
    
    @IBAction func cartButtonClicked(_ sender: UIBarButtonItem) {
        if cartVC == nil {
            cartVC = SB.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController
        }
        if let cartVC = cartVC {
            navigationController?.pushViewController(cartVC, animated: true)
        }
    }
}

extension MapScreenViewController: MapScreenViewModelOutputProtocol {
    func update() {
        print("update")
        collectionView.reloadData()
        updateUserLocationOnMap()
    }
    
    func error() {
        print("error")
    }
    
    func restaurantSelectionChanged() {
        collectionView.reloadData()
        if let selectedId = mapScreenViewModel.selectedRestaurantId,
           let index = mapScreenViewModel.productDetail.firstIndex(where: { $0.restaurant.restaurantId == selectedId }) {
            let indexPath = IndexPath(item: index, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}
